import MobileMenu from "../menu/mobile-menu/mobile-menu";

export default function Header() {
    return (
        <div className="h-[7.5%]">
            <div className = "flex h-full place-content-center bg-gradient-to-tl from-neutral-dark to-neutral text-neutral-content border-secondary border-b-2">
                <div className = "flex w-0 lg:w-1/5 items-center justify-center">
                    <div className="">
                        <h1 className="text-4xl invisible lg:visible">HEADER</h1>
                    </div>
                </div>

                <div className = "flex w-full lg:w-4/5 justify-center">
                    <div className="flex w-11/12 visible lg:invisible items-center justify-end">
                        <MobileMenu />
                    </div>
                </div>
            </div>
        </div>
        
    );
}