# Nginx Server Deployment on Render.com

This repository contains configuration for deploying a simple Nginx web server on Render.com using Docker.

## Project Structure

```
.
├── Dockerfile          # Docker configuration for Nginx
├── default.conf        # Nginx server configuration
├── public/             # Static website files
│   └── index.html      # Main HTML file
└── render.yaml         # Render.com deployment configuration
```

## Configuration Details

### Dockerfile

The Dockerfile sets up an Nginx server using the Alpine Linux base image for a lightweight container:

```dockerfile
FROM nginx:alpine

# Remove default NGINX website
RUN rm -rf /usr/share/nginx/html/*

# Copy custom configuration file
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy website files
COPY public /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### Nginx Configuration (default.conf)

Basic Nginx configuration that serves static content:

```nginx
server {
    listen 80;
    server_name localhost;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
```

### Render.com Deployment (render.yaml)

Configuration for deploying the service on Render.com:

```yaml
services:
  - type: web
    name: nginx-server
    env: docker
    repo: https://github.com/yourusername/your-repo
    plan: free
    branch: master
    dockerfilePath: ./Dockerfile
    autoDeploy: true
    envVars:
      - key: ENV
        value: production
      - key: API_URL
        value: https://api.yourdomain.com
    healthCheckPath: /
    healthCheckTimeout: 5s
```

## Deployment Instructions

### Prerequisites

- GitHub account
- Render.com account
- Git installed on your local machine

### Local Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/your-repo.git
   cd your-repo
   ```

2. Create your website files in the `public` directory:
   ```bash
   mkdir -p public
   echo '<html><body><h1>Hello from Nginx on Render!</h1></body></html>' > public/index.html
   ```

3. Test locally with Docker (optional):
   ```bash
   docker build -t nginx-test .
   docker run -p 8080:80 nginx-test
   ```
   
   Then visit http://localhost:8080 in your browser.

### Deploying to Render.com

1. Push your code to GitHub:
   ```bash
   git add .
   git commit -m "Setup Nginx server for Render.com"
   git push origin master
   ```

2. In your Render.com dashboard:
   - Click "New Web Service"
   - Select your GitHub repository
   - Render will automatically detect your `render.yaml` file
   - Click "Create Web Service"

3. Render will build and deploy your service automatically. Once deployed, you can access it at the URL provided by Render.

## Customization Options

### Custom Domain

1. In the Render dashboard, navigate to your service
2. Go to "Settings" > "Custom Domain"
3. Follow the instructions to add your domain

### Advanced Nginx Configuration

You can modify `default.conf` to add more complex configurations:

```nginx
server {
    listen 80;
    server_name localhost;

    # Enable gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript;

    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ /index.html;  # For Single Page Applications
    }

    # Example of API proxy
    location /api/ {
        proxy_pass ${API_URL};
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
        add_header Cache-Control "public, no-transform";
    }
}
```

### Environment Variables

You can add more environment variables in the `render.yaml` file:

```yaml
envVars:
  - key: ENV
    value: production
  - key: API_URL
    value: https://api.yourdomain.com
  - key: CUSTOM_HEADER
    value: "my-custom-value"
```

## Troubleshooting

- **Service fails to start**: Check the logs in the Render dashboard for error messages
- **Changes not reflecting**: Make sure you've committed and pushed your changes to the branch specified in `render.yaml`
- **Nginx configuration issues**: Validate your Nginx configuration with `nginx -t` locally before deploying

## Resources

- [Nginx Documentation](https://nginx.org/en/docs/)
- [Render.com Documentation](https://render.com/docs)
- [Docker Documentation](https://docs.docker.com/)
