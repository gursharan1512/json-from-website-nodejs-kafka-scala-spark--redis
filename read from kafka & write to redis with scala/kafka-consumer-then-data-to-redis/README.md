# kafka-consumer-then-data-to-redis

Code to consume data from kafka and then inserting to redis.

### Scala version - 2.11

## Dependencies

* Spark-core Dependency :
		<dependency>
			<groupId>org.apache.spark</groupId>
			<artifactId>spark-core_2.11</artifactId>
			<version>2.3.0</version>
		</dependency>
		
* Spark-streaming Dependency :
		<dependency>
			<groupId>org.apache.spark</groupId>
			<artifactId>spark-streaming_2.11</artifactId>
			<version>2.3.0</version>
		</dependency>
	  
* Kafka Dependency :
		<dependency>
			<groupId>org.apache.spark</groupId>
			<artifactId>spark-streaming-kafka-0-10_2.11</artifactId>
			<version>2.3.0</version>
		</dependency>

* Redis Dependency :
		<dependency>
			<groupId>redis.clients</groupId>
			<artifactId>jedis</artifactId>
			<version>2.8.1</version>
		</dependency>