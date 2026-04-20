
import { Request, Response } from "express"
import z, { ZodError } from "zod"
import { ChatRoom, DEFAULT_CORD } from "../model/chatroom.model";
import { objectIdSchema } from "../utils/zodhelper.utils";
import { getIO, UserIdSocketIdMap } from "../socket/socket";
import { User } from "../model/user.model";

const createRoomSchema = z.object({
    roomName: z.string().min(3).max(20),
    description: z.string().optional(),
    location: z.object({
        type: z.literal("Point"),
        coordinates: z.tuple([z.number(), z.number()]).default(DEFAULT_CORD),

    }).optional(),

});
const joinRoomSchema = z.object({
    roomId: objectIdSchema,
});

const fetchNearSchema = z.object({
    lat: z.coerce.number().min(-90).max(90).default(DEFAULT_CORD[1]),
    lng: z.coerce.number().min(-180).max(180).default(DEFAULT_CORD[0]),
    radius: z.coerce.number().positive().default(5000)              /// meters 

});

const paginatedSchema = z.object(
    {
        limit: z.coerce.number().int().positive().default(10),
        page: z.coerce.number().int().positive().default(1)
    }
);

const createRoom = async (req: Request, res: Response) => {
    try {

        if (!req.userId) {
            res.status(401).json({ error: "UnAuthorized" });
            return;
        }

        const {
            roomName,
            description,
            location
        } = createRoomSchema.parse(req.body);


        const newRoom = await ChatRoom.create({
            roomName,
            description,
            location,
            createdBy: req.userId,
            members: [req.userId]
        });

        const io = getIO();
        const socketIds = UserIdSocketIdMap[req.userId];

        if (socketIds) {
            for (const socketId of socketIds) {
                io.sockets.sockets.get(socketId)?.join(newRoom._id.toString());
            }
        }

        res.status(201).json({

            message: "room created succesfully ",
            newRoom
        });


    } catch (error) {

        if (error instanceof ZodError) {
            res.status(400).json({ error, message: "invalid requst body" })
        } else {
            res.status(500).json({ error, message: "something went wrong" })
        }

    }
}


const joinRoom = async (req: Request, res: Response) => {
    try {

        if (!req.userId) {
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const { roomId } = joinRoomSchema.parse(req.body);

        const room = await ChatRoom.findByIdAndUpdate(roomId, {
            $addToSet: { members: req.userId }
        }, { new: true });

        if (!room) {
            res.status(404).json({ error: "room not found" });
            return;
        }

        const user = await User.findById(req.userId).select("-password");

        if (!user) {
            res.status(404).json({ error: "user nor found" });
        }

        const io = getIO();
        const roomIdStr = room._id.toString();
        const socketIds = UserIdSocketIdMap[req.userId];

        if (socketIds) {
            for (const socketId of socketIds) {
                io.sockets.sockets.get(socketId)?.join(roomIdStr);
            }
        }

        io.to(roomIdStr).emit("room:user-joined", {
            roomId: roomIdStr,
            user,
        });

        res.status(200).json({
            message: "room joined succesfully ",
            roomId: room!._id
        });


    } catch (error) {
        if (error instanceof ZodError) {
            res.status(400).json({ error, message: "invalid requst body" })
        } else {
            res.status(500).json({ error, message: "something went wrong" })
        }


    }
}


const leaveRoom = async (
    req: Request<{ roomId: string }>,
    res: Response
) => {
    try {
        if (!req.userId) {
            return res.status(401).json({ error: "Unauthorized" });
        }

        const { roomId } = req.params;

        if (!roomId) {
            return res.status(400).json({ error: "roomId is required" });
        }

        // 1. Remove user from room (DB)
        const room = await ChatRoom.findByIdAndUpdate(
            roomId,
            {
                $pull: { members: req.userId } // ✅ REMOVE user
            },
            { new: true }
        );

        if (!room) {
            return res.status(404).json({ error: "room not found" });
        }

        const user = await User.findById(req.userId).select("-password");

        if (!user) {
            return res.status(404).json({ error: "user not found" });
        }

        // 2. Socket logic
        const io = getIO();
        const roomIdStr = room._id.toString();

        const socketIds = UserIdSocketIdMap[req.userId];

        if (socketIds) {
            for (const socketId of socketIds) {
                const socket = io.sockets.sockets.get(socketId);

                if (socket) {
                    socket.leave(roomIdStr); // ✅ LEAVE ROOM
                }
            }
        }

        // 3. Notify others
        io.to(roomIdStr).emit("room:user-left", {
            roomId: roomIdStr,
            user,
        });

        return res.status(200).json({
            message: "left room successfully",
            roomId: roomIdStr,
        });

    } catch (error) {
        if (error instanceof ZodError) {
            return res.status(400).json({
                error,
                message: "invalid request body",
            });
        }

        return res.status(500).json({
            error,
            message: "something went wrong",
        });
    }
};

const fetchRoomThatUserJoins = async (req: Request, res: Response) => {
    try {

        if (!req.userId) {
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const rooms = await ChatRoom.find(
            { members: req.userId }
        );

        res.status(200).json(rooms);

    } catch (error) {
        res.status(500).json({ error, message: "something went wrong" })

    }
}


const fetchById = async (req: Request<{ roomId: string }>, res: Response) => {

    try {

        const { roomId } = req.params;

        if (!roomId) {
            res.status(400).json({ error: "room id is reuired as the params" })
            return;
        }

        const room = await ChatRoom.findById(roomId)
            .populate("createdBy", "-password")
            .populate("members", "-password");

        if (!room) {
            res.status(404).json({ error: "room not found" })
            return;
        }

        res.status(200).json(room);



    } catch (error) {

        res.status(500).json({ error, message: "something went wrong" })

    }


}

const fetchAllRoom = async (req: Request, res: Response) => {
    try {

        const { limit, page } = paginatedSchema.parse(req.query);

        const skip = (page - 1) * limit;
        const rooms = await ChatRoom.find().skip(skip).limit(limit);

        const totalItems = await ChatRoom.countDocuments();

        const totalPages = Math.ceil(totalItems / limit);

        res.status(200).json({ rooms, page, limit, totalItems, totalPages });

    } catch (error) {
        if (error instanceof ZodError) {
            res.status(400).json({ error, message: "invalid requst body" })
        } else {
            res.status(500).json({ error, message: "something went wrong" })
        }
    }

}

const fetchNearBy = async (req: Request, res: Response) => {
    try {

        const { lat, lng, radius } = fetchNearSchema.parse(req.query);

        const rooms = await ChatRoom.find({
            location: {
                $near: {
                    $geometry: {
                        type: "Point",
                        coordinates: [lng, lat],
                    },
                    $maxDistance: radius
                }
            }
        });

        res.json(rooms);


    } catch (error) {
        if (error instanceof ZodError) {
            res.status(400).json({ error, message: "invalid requst body" })
        } else {
            res.status(500).json({ error, message: "something went wrong" })
        }

    }
}

export {
    createRoom,
    joinRoom,
    fetchAllRoom,
    fetchById,
    fetchNearBy,
    fetchRoomThatUserJoins, 
    leaveRoom

}