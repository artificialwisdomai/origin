export default function ChatInput() {
    return (
        <div className="flex pl-2 py-2 w-4/5">
            <textarea
                name="inputArea"
                id="inputArea"
                className="textarea w-full resize-none overflow-y-auto scrollbar scrollbar-primary textarea-primary-darker rounded-none bg-primary-darker placeholder-primary-light text-primary-light selection:bg-primary-light selection:text-primary-darker"
                placeholder="Chat Input">
            </textarea>
        </div>
    );
}