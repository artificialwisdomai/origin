// index.html
import Layout from '../components/layout';
import Chatbot from '../components/containers/chatbot-container';
import Sidebar from '../components/containers/sidebar-container';
import Header from '../components/containers/header-container';

export default function HomePage() {
  return (
    <>
      <title>Computelify, Inc.</title>
      <meta name="description" content="Computelify, Inc." />
      
      <div data-theme="awdark">
        <div className = "flex flex-col h-screen max-h-screen">
          <div className = "flex">
            <Layout />
          </div>


          <Header />


          <div className = "flex h-[92.5%] max-h-[92.5%]">
            <Sidebar />
            <Chatbot />
          </div>
        </div>
      </div>
    </>
  );
}