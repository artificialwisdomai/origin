
import NewChatButton from "../menu/chatbotButtons/new-chat-button";


import Searchbar from "../menu/chatbotButtons/searchbar";

import Chatlist from "../menu/chatList/chatlist";

import Signupbutton from "../menu/accountButtons/signup-button";
import Loginbutton from "../menu/accountButtons/login-button";
import Settingsbutton from "../menu/accountButtons/settings-button";

let currtext = null;

// This function saves the previous chat and then creates a new, empty chat
function createChatListItem() {
    let chatList = document.getElementById("chatListContainer");

    // if chatlist was empty, removes the placeholder text
    if (chatList.querySelector("#chatList-empty-text") != null) {
        chatList.removeChild(chatList.firstChild);
    };

    let newChat = document.createElement("div");
    newChat.className = "flex snap-start mb-2 p-2 h-auto w-auto bg-red-500";

    // TODO: add function to get the name of the previouschat
    newChat.innerText = "NEW CHAT (TESTING)";

    chatList.appendChild(newChat);
    console.log(chatList.innerHTML);
}

function handleNewChat() {
    // creates a new div in the chatList
    createChatListItem();

    // clears the chatArea
    clearChatArea();

    // clears the input area
let inputArea= document.getElementById("inputArea");
inputArea.value = "";

// You can pass formData as a fetch body directly:
    //fetch('/some-api', { method: form.method, body: formData });

// Or you can work with it as a plain object:
    //const formJson = Object.fromEntries(formData.entries());
    //console.log(formJson);
}


function clearChatArea() {
    const chatArea = document.getElementById("chatArea");
    while (chatArea.hasChildNodes()) {
        while (chatArea.firstChild.hasChildNodes()) {
            chatArea.firstChild.removeChild(chatArea.firstChild.firstChild);
        }
        chatArea.removeChild(chatArea.firstChild);
    }
  }



export default function Sidebar() {
    return (
        <>
        <div id="sidebar-container" className="flex flex-col w-0 lg:w-1/5 invisible lg:visible text-center h-full bg-sky-300">

            <div id="top-section" className="flex flex-col h-1/5 border-secondary border-r-2 bg-neutral">
                <div id="newChatButton" className="flex h-1/2 items-center justify-center" onClick={handleNewChat}>
                    <NewChatButton />
                </div>
                
                <div id="searchBar" className="flex h-1/2 items-center justify-center">
                    <Searchbar />
                </div>
            </div>

            <div className="flex w-full h-3/5 flex-wrap justify-center items-center overflow-hidden">
                <div id="chat-list" className="flex flex-wrap justify-center w-full h-full py-4 border-secondary border-r-2 bg-gradient-to-t from-neutral-dark to-neutral">
                    <Chatlist />
                </div>
            </div>

            <div id="bottom-section" className="flex flex-wrap justify-center h-1/5 border-secondary border-t-2 border-r-2 bg-black">

            <div id="signupButton" className="flex flex-wrap w-full h-1/2 place-content-center">
                    <Signupbutton />
                </div>

                <div id="bottomHalf" className="flex flex-wrap w-4/5 h-1/2 justify-between">
                    <div id="loginButton" className="flex flex-wrap w-3/4">
                        <Loginbutton />
                    </div>
                    <div id="settingsButton" className="flex flex-wrap w-1/5">
                        <Settingsbutton />
                    </div>
                </div>

            </div>




        </div>
        </>
    );
}