export default function ClearButton() {
    return (
        <button type="reset" className="flex btn btn-primary group w-4/5 p-1 my-2 bg-gradient-to-tl from-primary to-primary-light text-accent border-none hover:bg-gradient-to-tl hover:from-primary-dark hover:to-primary hover:text-accent ">
            <span id="buttonContent" className="flex items-center justify-center bg-primary-darker group-hover:bg-neutral-dark group-hover:text-primary-light rounded-md w-full h-full">Clear</span>
        </button>
    
    );
    }


