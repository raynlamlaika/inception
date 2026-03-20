
import { useState } from "react";

export default function BottomInput() {
  const [input, setInput] = useState("");

  const handleChange = (e) => {
    setInput(e.target.value);
  };

  const handleSubmit = () => {
    console.log("User input:", input);
    sendToBackend(input);
    setInput(""); // clear after submit
  };
  // send the buffer to the backend
  const sendToBackend = (data) => {
    // Implementation for sending data to backend
    // port in 1337
    fetch("http://localhost:1337/api/data", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ input: data })
    })
    .then(response => response.json())
    .then(data => {
        console.log("Success:", data);
    })
    .catch((error) => {
        console.error("Error:", error);
    });
  };


  return (
    <div
      style={{
        position: "fixed",
        bottom: "24px",
        left: "50%",
        transform: "translateX(-50%)",
        width: "100%",
        display: "flex",
        justifyContent: "center",
        pointerEvents: "none"
      }}
    >
      <div
        style={{
          display: "flex",
          alignItems: "center",
          gap: "12px",
          maxWidth: "640px",
          width: "90%",
          background: "rgba(21, 23, 30, 0.85)",
          backdropFilter: "blur(8px)",
          borderRadius: "999px",
          padding: "12px 20px",
          boxShadow: "0 15px 35px rgba(0, 0, 0, 0.35)",
          pointerEvents: "auto"
        }}
      >
        <input
          type="text"
          value={input}
          onChange={handleChange}
          placeholder="Type something..."
          style={{
            flex: 1,
            border: "none",
            background: "transparent",
            color: "#f7f7ff",
            fontSize: "1rem",
            outline: "none"
          }}
        />
        <button
          onClick={handleSubmit}
          style={{
            border: "none",
            borderRadius: "999px",
            padding: "10px 20px",
            fontWeight: 600,
            cursor: "pointer",
            color: "#0b0d17",
            background: "linear-gradient(135deg, #53d5ff, #7f78ff)",
            boxShadow: "0 10px 20px rgba(83, 213, 255, 0.35)",
            transition: "transform 0.15s ease, box-shadow 0.15s ease"
          }}
          onMouseDown={(e) => (e.currentTarget.style.transform = "scale(0.96)")}
          onMouseUp={(e) => (e.currentTarget.style.transform = "scale(1)")}
        >
          Send
        </button>
      </div>
    </div>
  );
}