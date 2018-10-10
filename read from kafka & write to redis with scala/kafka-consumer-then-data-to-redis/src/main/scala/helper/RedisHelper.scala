package helper

import com.google.gson.{JsonObject, JsonParser}
import org.apache.kafka.clients.consumer.ConsumerRecord
import org.apache.spark.streaming.dstream.InputDStream
import redis.clients.jedis.Jedis

class RedisHelper {

  def connecttoRedis() : Jedis = {
    val jedis = new Jedis("10.128.0.3")
    jedis.connect
    jedis.auth("JyUHvS1V5nP8")
    jedis
  }

  def createJsonStringForRedis(obj: JsonObject, parser: JsonParser) : JsonObject = {
    val obj2: JsonObject = parser.parse("{}").getAsJsonObject()
    obj2.addProperty("IPAddress",obj.get("userIp").getAsString)
    obj2.addProperty("TimeStamp",obj.get("t").getAsString)
    //obj2.addProperty("VisitorId",obj.get("v3").getAsString)
    //obj2.addProperty("LastVisitorId",obj.get("v4").getAsString)
    //obj2.addProperty("ClientId",obj.get("v5").getAsString)
    obj2.addProperty("SessionId",obj.get("v2").getAsString)
    //obj2.addProperty("RefererUrl",obj.get("r").getAsString)
    obj2.addProperty("PageUrl",obj.get("g").getAsString)
    obj2.addProperty("UserAgent",obj.get("user-agent").getAsString)
    println(obj2.toString)
    return obj2
  }

}
