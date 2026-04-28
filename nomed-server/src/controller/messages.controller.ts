import { Request, Response } from "express";
import z, { ZodError } from "zod";
import { objectIdSchema } from "../utils/zodhelper.utils";
import { ChatRoom } from "../model/chatroom.model";
import { Message } from "../model/message.model";
import { getIO } from "../socket/socket";


const sendMessageSchema = z.object({
    content: z.string().trim().min(1),
    roomId: objectIdSchema,
});

const fetchMessagePramsShcema = z.object({

    roomId: objectIdSchema,
});

const paginatedSchema = z.object(
    {
        limit: z.coerce.number().int().positive().default(50),
        page: z.coerce.number().int().positive().default(1)
    }
);



const fetchMessage = async (req: Request, res: Response) => {
    try {

        if (!req.userId) {
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const { roomId } = fetchMessagePramsShcema.parse(req.params);
        const { limit, page } = paginatedSchema.parse(req.query);

        const isMember = await ChatRoom.exists({
            _id: roomId,
            members: req.userId,
        });

        if (!isMember) {
            res.status(403).json({
                message: "You are not a member of this room",
            });
            return;
        }
        const skip = (page - 1) * limit;

        const messages = await Message.find(
            {
                roomId
            }
        ).sort({ createdAt: 1 })
            .skip(skip)
            .limit(limit)
            .populate('createdBy', 'username email')
            ;


        const totalItems = await Message.countDocuments({roomId});

        const totalPages = Math.ceil(totalItems / limit);

        res.status(200).json({ messages, page, limit, totalItems, totalPages });



    } catch (error) {
        if (error instanceof ZodError) {
            res.status(400).json({ error, message: "invalid requst body" })
        } else {
            res.status(500).json({ error, message: "something went wrong" })
        }
    }
}


const sendMessage = async (req: Request, res: Response) => {

    try {

        if (!req.userId) {
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const { content, roomId } = sendMessageSchema.parse(req.body);
        const room = await ChatRoom.exists({
            _id: roomId,
            members: req.userId,
        });

        if (!room) {
            res.status(404).json({ error: "room not found" });
            return;
        }


        const message = await Message.create({ content, roomId, createdBy: req.userId });

        const populatedMessage = await message.populate("createdBy", "username email");


        getIO().to(room._id.toString()).emit("message:update"
            , { message: populatedMessage });

        res.status(201).json({ message: "message created successfully", data: populatedMessage });


    } catch (error) {

        if (error instanceof ZodError) {
            res.status(400).json({ error, message: "invalid requst body" })
        } else {
            res.status(500).json({ error, message: "something went wrong" })
        }
    }

}


export {
    sendMessage,
    fetchMessage,
}