import { Server, Socket } from "socket.io";
import { ChatRoom } from "../model/chatroom.model";
import mongoose from "mongoose";

let io: Server | null = null;


export const UserIdSocketIdMap: Record<string, Set<string>> = {};

export const initSocket = (server: any): Server => {
    if (io) {
        console.warn("⚠️ Socket already initialized");
        return io;
    }

    io = new Server(server, {
        cors: {
            origin: "0.0.0.0",
            credentials: true,
        },
    });

    io.on("connection", (socket) => {
        console.log("⚡ Socket connected:", socket.id);

        const userId = socket.handshake.auth.userId;

        if (!UserIdSocketIdMap[userId]) {
            UserIdSocketIdMap[userId] = new Set();
        }
        UserIdSocketIdMap[userId].add(socket.id);

        joinUserRooms(socket, userId);



        // register events
        // chatEvent(io, socket);
        // roomEvent(io, socket);

        socket.on("disconnect", () => {
            console.log("❌ Socket disconnected:", socket.id);
            UserIdSocketIdMap[userId].delete(socket.id);
            if (UserIdSocketIdMap[userId].size === 0) {
                delete UserIdSocketIdMap[userId];
            }
        });
    });

    return io;
};


const joinUserRooms = async (
    socket: Socket,
    userId: string
) => {
    try {
        const rooms = await ChatRoom.find({
            members: new mongoose.Types.ObjectId(userId),
        }).select("_id");

        rooms.forEach((room) => {
            socket.join(room._id.toString());
        });

        console.log(
            `👥 User ${userId} joined ${rooms.length} rooms`
        );
    } catch (error) {
        console.error("❌ Failed to join user rooms:", error);
    }
};

export const getIO = (): Server => {
    if (!io) {
        throw new Error("❌ Socket.io not initialized. Call initSocket() first.");
    }
    return io;
};
