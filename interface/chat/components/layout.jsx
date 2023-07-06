// This component is used to build the layout of each page

export default function Layout({ children }) {
    return (
        <div className = "flex flex-row">
            <div>{children}</div>
        </div>
    );
}