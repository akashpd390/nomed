import request from 'supertest';
import app from '../src/app';
import { User } from '../src/model/user.model';
import { ChatRoom } from '../src/model/chatroom.model';
import { signToken } from '../src/utils/token.utils';
import mongoose from 'mongoose';

jest.mock('../src/socket/socket', () => ({
  initSocket: jest.fn(),
  getIO: jest.fn(() => ({
    to: jest.fn(() => ({ emit: jest.fn() })),
    sockets: { sockets: { get: jest.fn(() => ({ join: jest.fn() })) } }
  })),
  UserIdSocketIdMap: {}
}));

describe('Room API', () => {

  let userToken: string;
  let testUserId: string;

  beforeAll(async () => {
    // We apply spatial index manually inside the test for the memory server instance
    await ChatRoom.collection.createIndex({ location: "2dsphere" });

    const user = await User.create({
      username: 'roomtester',
      email: 'roomtester@test.com',
      password: 'password123'
    });
    testUserId = user._id.toString();
    userToken = signToken({ id: testUserId, email: user.email });
  });

  afterAll(async () => {
      await User.deleteMany({});
      await ChatRoom.deleteMany({});
  });

  describe('Room Interactions', () => {
    let createdRoomId: string;

    it('should create a room', async () => {
      const roomData = {
        roomName: 'Testing Room',
        description: 'Testing Description',
        location: {
            type: "Point",
            coordinates: [70.0, 30.0]        
        }
      };

      const res = await request(app)
        .post('/api/room')
        .set('Authorization', `Bearer ${userToken}`)
        .send(roomData);
        
      expect(res.status).toBe(201);
      expect(res.body).toHaveProperty('message', 'room created succesfully ');
      expect(res.body.newRoom).toHaveProperty('roomName', roomData.roomName);
      
      createdRoomId = res.body.newRoom._id;
    });

    it('should fail to create a room with invalid data', async () => {
      const res = await request(app)
        .post('/api/room')
        .set('Authorization', `Bearer ${userToken}`)
        .send({ roomName: 'a' }); // name too short
        
      expect(res.status).toBe(400);
      expect(res.body.message).toBe('invalid requst body');
    });

    it('should allow joining a room', async () => {
      const roomToJoin = await ChatRoom.create({
          roomName: 'Another Room',
          createdBy: new mongoose.Types.ObjectId(),
          members: []
      });

      const res = await request(app)
        .post('/api/room/join')
        .set('Authorization', `Bearer ${userToken}`)
        .send({ roomId: roomToJoin._id.toString() });
        
      expect(res.status).toBe(200);
      expect(res.body.message).toBe('room joined succesfully ');
    });

    it('should fetch joined rooms', async () => {
      const res = await request(app)
        .get('/api/room/')
        .set('Authorization', `Bearer ${userToken}`);
        
      expect(res.status).toBe(200);
      expect(Array.isArray(res.body)).toBe(true);
      expect(res.body.length).toBeGreaterThanOrEqual(1);
    });

    it('should fetch room by ID', async () => {
      const res = await request(app)
        .get(`/api/room/${createdRoomId}`)
        .set('Authorization', `Bearer ${userToken}`);
        
      expect(res.status).toBe(200);
      expect(res.body._id).toBe(createdRoomId);
    });

    it('should fetch all rooms paginated', async () => {
      const res = await request(app)
        .get(`/api/room/all?page=1&limit=10`)
        .set('Authorization', `Bearer ${userToken}`);
        
      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty('rooms');
      expect(Array.isArray(res.body.rooms)).toBe(true);
    });

    it('should fetch nearby rooms', async () => {
      const res = await request(app)
        .get(`/api/room/near?lat=30.0&lng=70.0&radius=10000`)
        .set('Authorization', `Bearer ${userToken}`);
        
      expect(res.status).toBe(200);
      expect(Array.isArray(res.body)).toBe(true);
      expect(res.body.some((r: any) => r._id === createdRoomId)).toBeTruthy();
    });

  });

});
