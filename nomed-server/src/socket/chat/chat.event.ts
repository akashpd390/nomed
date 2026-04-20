import { Server, Socket } from "socket.io";
import z from "zod";
import { objectIdSchema } from "../../utils/zodhelper.utils";


const messageSendSchema = z.object({
    roomId: objectIdSchema,
    createdBy: objectIdSchema,
    content: z.string().trim().min(1),
});

const chatEvent = (io: Server, socket: Socket) => {

    socket.on("message:send", (payload) => {

        const result = messageSendSchema.safeParse(payload);

        if (!result.success) {
            socket.emit("message:error", { message: "Invalid payload", error: result.error });
            return;
        }

        const { roomId, createdBy, content } = result.data;
        io.to(roomId).emit("message:new", {
            roomId, createdBy, content
        });
    });
}



export default chatEvent;