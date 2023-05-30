import React, {useEffect} from "react";
import ChatArea from "./chat-area";

export default function ChatOutput() {
    return (
        <div id="chatOutput" className="flex w-full h-full">
            <ChatArea />
        </div>
    );
}