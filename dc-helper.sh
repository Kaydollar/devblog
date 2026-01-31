#!/bin/bash

# Function to show help
show_help() {
    echo "DevBlog Docker Compose Helper"
    echo "============================="
    echo "Usage: ./dc-helper.sh <command> [service]"
    echo ""
    echo "Commands:"
    echo "  up [service]      Start all services, or a specific service"
    echo "  down [service]    Stop all services, or a specific service"
    echo "  build [service]   Build all services, or a specific service"
    echo "  restart [service] Restart all services, or a specific service"
    echo "  logs [service]    View logs (all or specific). Use -f to follow"
    echo "  status [service]  Show status of all or a specific container"
    echo "  seed              Create admin user (run seeding script)"
    echo "  shell <service>   Open a shell inside a container"
    echo "  clean             Stop containers and remove volumes (DESTRUCTIVE)"
    echo "  help              Show this help message"
}

case $1 in
    up)
        docker-compose up -d $2
        ;;
    down)
        docker-compose stop $2
        ;;
    build)
        docker-compose build $2
        ;;
    restart)
        docker-compose restart $2
        ;;
    logs)
        if [ "$2" == "-f" ]; then
            docker-compose logs -f $3
        else
            docker-compose logs $2
        fi
        ;;
    status)
        docker-compose ps $2
        ;;
    seed)
        echo "Running Database Seed..."
        # We use the exact variable name found in your utils/db.js
        docker-compose exec -e MONGO_URI=mongodb://mongo:27017/devblog web node create-user-cli.js
        ;;
    shell)
        if [ "$2" == "mongo" ]; then
            docker-compose exec mongo mongosh
        else
            docker-compose exec "$2" sh
        fi
        ;;
    clean)
        echo "WARNING: Removing containers and volumes!"
        docker-compose down -v
        ;;
    help|*)
        show_help
        ;;
esac