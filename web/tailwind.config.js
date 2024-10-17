/** @type {import('tailwindcss').Config} */
export default {
    content: [
        "./index.html",
        "./src/**/*.{js,ts,jsx,tsx}",
    ],
    theme: {
        extend: {
            fontFamily: {
                'poppins': ['Poppins', 'system-ui'],
            },
            fontWeight: {
                'extralight': '200',
                'regular': '400',
                'semibold': '600',
                'extrabold': '800',
            },
            fontStyle: {
                'italic': 'italic',
                'normal': 'normal',
            },
        },
    },
    plugins: [],
}

