

### Installation

# Start User interface 

1. Enter your API in `user_interface/client/src/components/home/HomePage.js`
   ```js
    const [apiEndpoint, setApiEndpoint] = 'ENTER YOUR API';
   ```
2. Create your image
   ```sh
   docker_load_push.sh   
   ```

3. Start React UI locally
     ```sh
   cd user_interface/client
   ```
   ```sh
   npm install
   ```
    ```sh
   npm start
   ```

