import node_resolve from 'rollup-plugin-node-resolve';
import livereload from 'rollup-plugin-livereload';
import sass from 'rollup-plugin-sass';

import { resolve } from 'path';

export default {
    input: './src/main.bs.js',
    output: {
        name: 'phoneqBucklescript',
        file: './release/main.js',
        format: 'iife'
    },
    plugins: [
        node_resolve({module: true, browser: true}),
        livereload('release'),
        sass({
            output: './release/style.css',
            options: {
                includePaths: [resolve(__dirname, 'node_modules')]
            }
        })
    ],
    watch: {
        clearScreen: false
    }
}
