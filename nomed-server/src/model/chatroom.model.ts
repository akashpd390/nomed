import mongoose from "mongoose";
import { string } from "zod";

export const DEFAULT_CORD: [number, number] = [77.2090, 28.6139];



export interface IChatRoom extends mongoose.Document {
    roomName: string,
    description?: string,
    location: {
        type: "Point",
        coordinates: [number, number]    // lng lat
    },
    createdBy: mongoose.Types.ObjectId | string,
    members: mongoose.Types.ObjectId[] | string[]
}


const chatRoomSchema = new mongoose.Schema<IChatRoom>({
    roomName: {
        type: String,
        required: true

    }, location: {
        type: {
            type: String,
            enum: ["Point"],
            default: "Point",
            required: true,
        },
        coordinates: {
            type: [Number],
            default: [77.2090, 28.6139],
            // default: DEFAULT_CORD,
            required: true,
        },
    },
    description: {
        type: String,

    },
    members: [{
        type: mongoose.Schema.ObjectId,
        ref: 'user'
    }],
    createdBy: {
        type: mongoose.Schema.ObjectId,
        ref: 'user'
    }


}, { timestamps: true });

chatRoomSchema.index({ location: "2dsphere" });

export const ChatRoom = mongoose.model<IChatRoom>('chatRoom', chatRoomSchema);