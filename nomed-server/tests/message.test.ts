import request from 'supertest';
import app from '../src/app';
import { User } from '../src/model/user.model';
import { ChatRoom } from '../src/model/chatroom.model';
import { Message } from '../src/model/message.model';
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

describe('Message API', () => {

  let userToken: string;
  let testUserId: string;
  let roomId: string;
  let unauthorizedUserToken: string;

  beforeAll(async () => {
    const user = await User.create({
      username: 'messagetester',
      email: 'messagetester@test.com',
      password: 'password123'
    });
    testUserId = user._id.toString();
    userToken = signToken({ id: testUserId, email: user.email });

    const unauthorizedUser = await User.create({
        username: 'unauthuser',
        email: 'unauthuser@test.com',
        password: 'password123'
    });
    unauthorizedUserToken = signToken({ id: unauthorizedUser._id.toString(), email: unauthorizedUser.email });

    const room = await ChatRoom.create({
      roomName: 'Message Room',
      createdBy: testUserId,
      members: [testUserId]
    });
    roomId = room._id.toString();
  });

  afterAll(async () => {
    await User.deleteMany({});
    await ChatRoom.deleteMany({});
    await Message.deleteMany({});
  });

  describe('Message Operations', () => {

    it('should send a message to a joined room', async () => {
      const res = await request(app)
        .post('/api/message')
        .set('Authorization', `Bearer ${userToken}`)
        .send({ content: 'Hello World', roomId });
        
      expect(res.status).toBe(201);
      expect(res.body.message).toBe('message created successfully');
      expect(res.body.data.content).toBe('Hello World');
    });

    it('should fail to send a message to a room user is not mapped to', async () => {
      const res = await request(app)
        .post('/api/message')
        .set('Authorization', `Bearer ${unauthorizedUserToken}`)
        .send({ content: 'Hello World', roomId });
        
      expect(res.status).toBe(404); // the existing controller uses 404 for room not found/member check
      expect(res.body.error).toBe('room not found');
    });

    it('should fetch messages from a joined room', async () => {
      const res = await request(app)
        .get(`/api/message/${roomId}`)
        .set('Authorization', `Bearer ${userToken}`);
        
      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty('messages');
      expect(Array.isArray(res.body.messages)).toBe(true);
      expect(res.body.messages.length).toBeGreaterThanOrEqual(1);
      expect(res.body.messages[0].content).toBe('Hello World');
    });

    it('should fail to fetch messages if not a member', async () => {
      const res = await request(app)
        .get(`/api/message/${roomId}`)
        .set('Authorization', `Bearer ${unauthorizedUserToken}`);
        
      expect(res.status).toBe(403);
      expect(res.body.message).toBe('You are not a member of this room');
    });

  });

});
