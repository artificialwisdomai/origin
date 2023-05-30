export default function SignupButton() {
    return (
        <button className="flex btn btn-secondary group w-4/5 p-1 my-1 bg-gradient-to-tl from-secondary-dark to-secondary-light text-accent border-none hover:bg-gradient-to-tl hover:from-secondary-darker hover:to-secondary">
            <span className="flex items-center justify-center bg-secondary-darker group-hover:text-secondary-light group-hover:bg-neutral-dark font-semibold rounded-md w-full h-full">Sign Up!</span>
        </button>
    );
}