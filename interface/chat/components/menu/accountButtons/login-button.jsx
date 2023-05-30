export default function LoginButton() {
    return (
        <button className="flex btn btn-primary group w-full p-1 my-2 bg-gradient-to-tl from-primary to-primary-light text-accent border-none hover:bg-gradient-to-tl hover:from-primary-dark hover:to-primary hover:text-accent">
            <span className="flex items-center justify-center bg-primary-darker group-hover:bg-neutral-dark group-hover:text-primary-light rounded-md w-full h-full">Login</span>
        </button>
    );
}