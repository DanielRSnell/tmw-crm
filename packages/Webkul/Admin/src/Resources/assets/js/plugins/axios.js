/**
 * We'll load the axios HTTP library which allows us to easily issue requests
 * to our Laravel back-end. This library automatically handles sending the
 * CSRF token as a header based on the value of the "XSRF" token cookie.
 */
import axios from "axios";
window.axios = axios;
window.axios.defaults.headers.common["X-Requested-With"] = "XMLHttpRequest";

/**
 * Fix for mixed content errors when behind HTTPS proxy (Krayin v2.1 bug fix)
 * Automatically converts all HTTP URLs to HTTPS to prevent browser blocking
 */
axios.interceptors.request.use(function (config) {
    // Force HTTPS for all requests if the page is loaded over HTTPS
    if (window.location.protocol === 'https:' && config.url) {
        config.url = config.url.replace(/^http:/, 'https:');
    }
    return config;
}, function (error) {
    return Promise.reject(error);
});

export default {
    install(app) {
        app.config.globalProperties.$axios = axios;
    },
};
