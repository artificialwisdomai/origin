// This component is the replacement for the sidebar on mobile devices

export default function MobileMenu() {

    return (
        <div className="dropdown dropdown-end">
            <label tabIndex={0} className="btn btn-primary m-1">Menu</label>
            <ul tabIndex={0} className="dropdown-content menu p-2 shadow bg-base-100 rounded-box w-52">
                <li><a>Item 1</a></li>
                <li><a>Item 2</a></li>
            </ul>
        </div>
    );
}

// TODO: implement the menu