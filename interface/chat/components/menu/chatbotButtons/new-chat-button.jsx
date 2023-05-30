export default function NewChatButton({onSend}) {
    return (
        <button className="flex btn btn-primary group w-4/5 p-1 my-2 bg-gradient-to-tl from-primary to-primary-light text-accent border-none hover:bg-gradient-to-tl hover:from-primary-dark hover:to-primary hover:text-accent" onClick={onSend}>
            <span className="block bg-primary-darker group-hover:bg-neutral-dark group-hover:text-primary-light px-4 py-3 rounded-md w-full h-full">New Chat</span>
        </button>
    );
}