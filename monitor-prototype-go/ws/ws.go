package main

import (
	"github.com/garyburd/redigo/redis"
	"github.com/gorilla/websocket"
	"log"
	"net/http"
)

func main() {
	c, err := redis.Dial("tcp", ":6379")
	if err != nil {
		log.Fatal(err)
	}
	defer c.Close()

	pubsub := redis.PubSubConn{c}
	pubsub.Subscribe("events")
	defer pubsub.Close()

	http.Handle("/", handler(pubsub))
	if err := http.ListenAndServe(":8080", nil); err != nil {
			log.Fatal("ListenAndServe:", err)
	}
}

var upgrader = websocket.Upgrader{
	CheckOrigin: func(_ *http.Request) bool {
		return true
	},
}

func handler(pubsub redis.PubSubConn) http.HandlerFunc {
	return http.HandlerFunc(func (w http.ResponseWriter, r *http.Request) {
		conn, err := upgrader.Upgrade(w, r, nil)
		if err != nil {
			log.Println(err)
			return
		}
		for {
        switch n := pubsub.Receive().(type) {
        case redis.Message:
          log.Println("received a publish message...", n.Data)
					conn.WriteMessage(websocket.TextMessage, n.Data)
        case error:
          log.Println("error:", n)
          break
        }
    }
	})
}
