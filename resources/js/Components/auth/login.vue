<template>
    <div class="auth-container">
        <h2>Login</h2>
        <form @submit.prevent="login">
            <div class="form-group">
                <label for="email">Email</label>
                <input
                    v-model="email"
                    type="email"
                    id="email"
                    placeholder="Enter your email"
                    required
                />
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input
                    v-model="password"
                    type="password"
                    id="password"
                    placeholder="Enter your password"
                    required
                />
            </div>
            <button type="submit" :disabled="loading">Login</button>
            <p v-if="error" class="error">{{ error }}</p>
        </form>
    </div>
</template>

<script>
import axios from "axios";

export default {
    data() {
        return {
            email: "",
            password: "",
            loading: false,
            error: null,
        };
    },
    methods: {
        async login() {
            this.error = null;
            this.loading = true;

            try {
                const response = await axios.post(
                    "https://cunusltation.onrender.com/api/login",
                    {
                        email: this.email,
                        password: this.password,
                    },
                    {
                        headers: {
                            Accept: "application/json",
                        },
                    }
                );
                console.log("Login success:", response.data);

                localStorage.setItem("token", response.data.token);
                this.$router.push("/home");
            } catch (err) {
                console.error("Login failed:", err);
                this.error = "Invalid credentials";
            } finally {
                this.loading = false;
            }
        },
    },
};
</script>

<style scoped>
.auth-container {
    max-width: 400px;
    margin: auto;
}
.error {
    color: red;
    font-size: 14px;
}
</style>
