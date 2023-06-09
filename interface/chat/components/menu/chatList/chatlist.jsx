// This component is a list of all of the user's saved chats
// At first it's empty, but as the user creates more chats, they will be added to the list

export default function Chatlist() {
    return (
        <div className="flex w-4/5 h-full p-1 bg-gradient-to-tl from-primary to-primary-light overflow-hidden">
            <div id="chatListContainer" className = "flex flex-col w-full h-full max-h-full resize-none pl-2 py-2 overflow-y-auto scrollbar scrollbar-hidden snap-y scroll-pt-2 bg-primary-darker overflow-x-hidden rounded-none">
                <p id="chatList-empty-text" className="text-sm text-accent"> Your previous chats will be stored here! </p>
            </div>
        </div>
    );
}

// TODO: add functionality, add behavior for if the user is not logged in