import ChatOutput from "../chatbot/chat-output";
import ChatInput from "../chatbot/chat-input";
import SendChatInput from "../menu/chatbotButtons/send-chat-input";

import ClearButton from "../menu/accountButtons/clear-button";

import React, {useState} from "react";

export default function Chatbot() {
    // these have to be here or else it breaks :)
    let formJson = null;
    let currtext = null;

    function handleSubmit(e) {
            // prevents the browser from reloading the page
        e.preventDefault();
    
            // reads the form data
        const form = e.target;
        const formData = new FormData(form);

        const currtext = formData.get("inputArea");

            // if input is empty, nothing happens
        if (currtext === "") {
            return;
        }

            // creates a new chat bubble w/ the input text inside of it, and puts it into the chat area
        let newChatBubbleContainer = document.createElement("div");
        newChatBubbleContainer.id = "chatBubbleContainer";
        newChatBubbleContainer.className = "chat chat-end w-1/2 p-2 m-2 w-auto";
        
        let newChatBubble = document.createElement("div");
        newChatBubble.id = "chatBubble";
        newChatBubble.className = "chat-bubble bg-primary-light text-primary-darker flex-wrap";
        newChatBubble.innerText = currtext;

        newChatBubbleContainer.appendChild(newChatBubble);
        chatArea.appendChild(newChatBubbleContainer);
        
            // clears the input area
        inputArea.value = "";

            // auto-scrolls to the bottom of the chat area
        chatArea.scrollTop = chatArea.scrollHeight;
        
        
        // You can pass formData as a fetch body directly:
            //fetch('/some-api', { method: form.method, body: formData });
    
        // Or you can work with it as a plain object:
            //const formJson = Object.fromEntries(formData.entries());
            //console.log(formJson);
    }

    return (
        <form onSubmit={handleSubmit} className="w-full lg:w-4/5 h-full overflow-clip bg-gradient-to-b from-neutral-light to-neutral">
            <div id="output" className="flex flex-wrap justify-center h-2/3 lg:h-4/5">
                <div className="flex w-full h-full flex-wrap justify-center items-center overflow-hidden bg-gradient-to-t from-black to-neutral-dark">
                    <ChatOutput />
                </div>                
            </div>

            <div id="input" className="flex flex-wrap h-1/3 lg:h-1/5 justify-center">
                <div className="flex w-full flex-wrap bg-neutral-dark border-secondary border-t-2">                
                    <ChatInput />
                    <div className="flex flex-wrap w-1/5 place-content-center">
                        <SendChatInput />
                        <ClearButton />
                    </div>
                </div>
            </div>
        </form>
    );
}