// this component is a button that when clicked, sends the user's message from the chat input to the chatbot & the output area

import React, {useEffect} from "react";

export default function SendChatInput({onSend}) {
    return (
        <button id="sendBtn" type="submit" className="flex btn btn-secondary-test group w-4/5 p-1 my-1 bg-gradient-to-tl from-secondary-dark to-secondary-light text-accent border-none hover:bg-gradient-to-tl hover:from-secondary-darker hover:to-secondary" onClick={onSend}>
            <span className="flex items-center justify-center bg-secondary-darker group-hover:text-secondary-light group-hover:bg-neutral-dark font-semibold rounded-md w-full h-full">Send</span>
        </button>
    );
}

// TODO: add functionality (send input to backend)