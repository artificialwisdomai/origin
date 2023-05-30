export default function Layout({ children }) {
    return (

        <div className = "flex flex-row">
            <div>{children}</div>
        </div>

    );
}