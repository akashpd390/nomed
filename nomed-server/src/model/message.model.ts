import mongoose, { mongo } from "mongoose";



export interface IMessage extends mongoose.Document {
    content: string,
    createdBy: mongoose.Types.ObjectId | string,
    roomId: mongoose.Types.ObjectId | string,

}


const messageSchema = new mongoose.Schema<IMessage>(
    {
        content: {
            type: String,
            required: true,

        },

        createdBy: {
            type: mongoose.Schema.ObjectId,
            ref: 'user',
            required: true
        },
        roomId: {
            type: mongoose.Schema.ObjectId,
            ref: "chatRoom",
            required: true
        }
    }, { timestamps: true }
);


export const Message = mongoose.model<IMessage>('message', messageSchema);