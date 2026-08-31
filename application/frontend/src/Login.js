import React, { useState } from "react";
import "./Login.css";

function Login({ onLoginSuccess }) {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();

    if (!username.trim() || !password.trim()) {
      setError("Please fill in all fields.");
      return;
    }

    // Replace this with a real API call to your app tier, e.g.:
    // fetch(`${API_URL}/login`, {
    //   method: "POST",
    //   headers: { "Content-Type": "application/json" },
    //   body: JSON.stringify({ username, password }),
    // })
    //   .then((res) => res.json())
    //   .then((data) => {
    //     if (data.success) {
    //       onLoginSuccess();
    //     } else {
    //       setError(data.message || "Invalid credentials.");
    //     }
    //   })
    //   .catch(() => setError("Server error. Try again."));

    // Temporary placeholder so you can test the flow before backend is ready:
    setError("");
    onLoginSuccess();
  };

  return (
    <div className="login-container">
      <h1>Welcome Back</h1>
      <p className="subtitle">Log in to continue to your account</p>

      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="username">Username or Email</label>
          <input
            type="text"
            id="username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            placeholder="Enter your username"
          />
        </div>

        <div className="form-group">
          <label htmlFor="password">Password</label>
          <input
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Enter your password"
          />
        </div>

        {error && <div className="error-msg">{error}</div>}

        <div className="options-row">
          <label>
            <input type="checkbox" /> Remember me
          </label>
          <a href="/forgot-password">Forgot password?</a>
        </div>

        <button type="submit" className="btn-login">
          Log In
        </button>
      </form>

      <p className="signup-text">
        Don't have an account? <a href="/signup">Sign up</a>
      </p>
    </div>
  );
}

export default Login;
