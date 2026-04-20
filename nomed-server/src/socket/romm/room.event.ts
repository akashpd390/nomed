import { Server, Socket } from "socket.io";
import z from "zod";
import { objectIdSchema } from "../../utils/zodhelper.utils";
import { ChatRoom } from "../../model/chatroom.model";


const roomJoinSchema = z.object({
    roomId: objectIdSchema,
    userId: objectIdSchema,
});


const roomEvent = (io: Server, socket: Socket) => {

    socket.on("room:join", async (payload) => {

        const result = roomJoinSchema.safeParse(payload);

        if (!result.success) {
            socket.emit("room:error", { message: "Invalid Payload", error: result.error })
            return;
        }

        const data = result.data;

        const room = ChatRoom.findByIdAndUpdate(data.roomId, {

            $addToSet: { members: data.userId }
        }, { new: true });

        

        socket.join(data.roomId);



        io.to(data.roomId).emit("room:user-joined", { data });

    });


    socket.on("room:leave", (payload) => {
        const result = roomJoinSchema.safeParse(payload);


        if (!result.success) {
            socket.emit("room:error", { message: "Invalid Payload", error: result.error })
            return;

        }

        const data = result.data;

        io.to(data.roomId).emit("room:user-leave", { data });


    })

}


export default roomEvent;