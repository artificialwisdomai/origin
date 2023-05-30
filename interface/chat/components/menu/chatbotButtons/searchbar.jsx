export default function Searchbar() {
    return (
        <form className="flex max-w-xs w-4/5 h-5/6 items-center">   
            <label className="sr-only">Search</label>
            <div className="flex w-full h-full relative items-center justify-center">
                <div className="flex absolute inset-y-0 left-0 items-center pl-3 pointer-events-none">
                    <svg aria-hidden="true" className="w-5/6 h-5 " fill="#ffffff" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fillRule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clipRule="evenodd"></path></svg>
                </div>
                <input type="text" id="search" className="bg-primary rounded-full font-mono text-sm text-white focus:bg-primary-focus placeholder-primary-content block w-full h-5/6 pl-10 p-2.5" placeholder="Search previous chats"/>
            </div>
            <button type="submit" className="btn btn-circle btn-primary flex p-2.5 ml-2 text-sm font-medium rounded-full focus:ring-4 focus:outline-none">
                <svg className="w-5 h-5" fill="none" stroke="#ffffff" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                <span className="sr-only">Search</span>
            </button>
        </form>
    );
}