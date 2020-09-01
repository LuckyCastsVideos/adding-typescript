# RailsByte at https://railsbytes.com/script/zl0sNL

def set_up_tsconfig
  create_file "tsconfig.json" do<<~EOF
    {
      "compilerOptions": {
        "declaration": false,
        "emitDecoratorMetadata": true,
        "experimentalDecorators": true,
        "esModuleInterop": true,
        "lib": ["es6", "dom"],
        "module": "es6",
        "moduleResolution": "node",
        "baseUrl": ".",
        "typeRoots": ["node_modules/@types"],
        "paths": {
          "*": ["node_modules/*", "app/js/*"]
        },
        "sourceMap": true,
        "target": "es5",
        "strict": true,
        "alwaysStrict": true
      },
      "exclude": ["node_modules", "lib", "public"],
      "compileOnSave": false
    }
    EOF
  end
end

def set_up_eslintrc
  create_file ".eslintrc.js" do<<~EOF
    module.exports = {
      root: true,
      parser: '@typescript-eslint/parser',
      plugins: [
        '@typescript-eslint',
      ],
      extends: [
        'eslint:recommended',
        'plugin:@typescript-eslint/recommended',
      ],
    };
    EOF
  end
end

def convert_webpack_mix_to_typescript
  gsub_file "webpack.mix.js",
    '.js("src/js/app.js", "public/js")',
    '.ts("src/js/app.ts", "public/js/app.js")'
end

def yarn_dev(*packages)
  run("yarn add -D #{packages.join(" ")}")
end

say "Adding required yarn packages for TypeScript web development...", :yellow
yarn_dev "@types/node", "@types/webpack-env", "typescript", "ts-loader"
say "Done.", :green

say "Adding tsconfig.json file for TypeScript configuration...", :yellow
set_up_tsconfig
say "Done.", :green

say "Telling webpack.mix.js to process TypeScript...", :yellow
convert_webpack_mix_to_typescript
say "Done.", :green

say "Converting src/js/app.js to src/js/app.ts...", :yellow
run "mv src/js/app.js src/js/app.ts"
say "Done.", :green

if yes?("Would you like to set up ESLint for TypeScript development? [y/N]", :yellow)
  say "Installing required ESLint yarn packages for TypeScript...", :yellow
  yarn_dev "eslint", "@typescript-eslint/parser", "@typescript-eslint/eslint-plugin"
  set_up_eslintrc
  say "Done.", :green
end

say "All done! Restart your server with `lucky dev` to start using TypeScript!"
