#!/bin/bash

# Control script for Project1 file monitoring
# Usage: ./monitor_control.sh [start|stop|status|restart]

PROJECT_DIR="$(pwd)"
MONITOR_SCRIPT="$PROJECT_DIR/file_monitor.sh"
PID_FILE="/tmp/project1_monitor.pid"
LOG_FILE="$PROJECT_DIR/monitor.log"

start_monitor() {
    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        echo "File monitor is already running (PID: $(cat "$PID_FILE"))"
        return 1
    fi
    
    echo "Starting Project1 file monitor..."
    nohup "$MONITOR_SCRIPT" > /dev/null 2>&1 &
    echo $! > "$PID_FILE"
    echo "File monitor started (PID: $!)"
    echo "Monitor log: $LOG_FILE"
    echo "Use 'tail -f $LOG_FILE' to watch activity"
    return 0
}

stop_monitor() {
    if [ ! -f "$PID_FILE" ]; then
        echo "File monitor is not running"
        return 1
    fi
    
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        echo "Stopping file monitor (PID: $PID)..."
        kill "$PID"
        sleep 2
        
        # Force kill if still running
        if kill -0 "$PID" 2>/dev/null; then
            echo "Force stopping monitor..."
            kill -9 "$PID"
        fi
        
        rm -f "$PID_FILE"
        echo "File monitor stopped"
    else
        echo "File monitor process not found, cleaning up PID file"
        rm -f "$PID_FILE"
    fi
    return 0
}

status_monitor() {
    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        echo "File monitor is running (PID: $(cat "$PID_FILE"))"
        echo "Monitor log: $LOG_FILE"
        echo ""
        echo "Recent activity (last 5 lines):"
        tail -5 "$LOG_FILE" 2>/dev/null || echo "No log entries found"
    else
        echo "File monitor is not running"
        [ -f "$PID_FILE" ] && rm -f "$PID_FILE"
    fi
}

case "$1" in
    start)
        start_monitor
        ;;
    stop)
        stop_monitor
        ;;
    restart)
        stop_monitor
        sleep 1
        start_monitor
        ;;
    status)
        status_monitor
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        echo ""
        echo "Commands:"
        echo "  start   - Start automatic file monitoring"
        echo "  stop    - Stop file monitoring"
        echo "  restart - Stop and start monitoring"
        echo "  status  - Show current monitoring status"
        echo ""
        echo "Examples:"
        echo "  ./monitor_control.sh start"
        echo "  ./monitor_control.sh status"
        echo "  tail -f monitor.log  # Watch live activity"
        exit 1
        ;;
esac 