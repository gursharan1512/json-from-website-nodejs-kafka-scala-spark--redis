package runner

import java.util.Properties

import com.google.gson.{JsonObject, JsonParser}
import helper.{KafkaHelper, RedisHelper}
import javax.mail.internet.{InternetAddress, MimeMessage}
import javax.mail._
import org.apache.kafka.clients.consumer.ConsumerRecord
import org.apache.spark.SparkConf
import org.apache.spark.streaming.{Seconds, StreamingContext}
import org.apache.spark.streaming.dstream.InputDStream

object Test {
  def main(args: Array[String]): Unit = {

    def main(args : Array[String]): Unit = {
     sendMail("sharanghotra1512@gmail.com", "kapil@chutiya","sharanghotra15121512@gmail.com", "SubJect3", "sefawerfdsfsdffMessage")
    }

    def sendMail(from : String,password : String,to : String,sub : String,msg : String): Unit = {
      //Get properties object
      val props : Properties = new Properties()
      props.put("mail.smtp.host", "smtp.gmail.com")
      props.put("mail.smtp.socketFactory.port", "465")
      props.put("mail.smtp.socketFactory.class",
        "javax.net.ssl.SSLSocketFactory")
      props.put("mail.smtp.auth", "true")
      props.put("mail.smtp.port", "465")
      //get Session
      val session : Session= Session.getDefaultInstance(props,
        new javax.mail.Authenticator() {
          override protected def getPasswordAuthentication() : PasswordAuthentication = {
            return new PasswordAuthentication(from,password)
          }
        });
      //compose message
      try {
        val message : MimeMessage = new MimeMessage(session)
        message.addRecipient(Message.RecipientType.TO,new InternetAddress(to))
        message.setSubject(sub)
        message.setText(msg)
        //send message
        Transport.send(message)
        System.out.println("message sent successfully")
      } catch {
        case e: MessagingException => throw new RuntimeException(e);
      }
    }
    /*val conf = new SparkConf().setMaster("local[*]").setAppName("KafkaReceiver")
    val ssc = new StreamingContext(conf, Seconds(5))

    val kafkaStream :InputDStream[ConsumerRecord[String,String]] = new KafkaHelper().readKafkaStream(ssc)

    kafkaStream.foreachRDD(rdd => {
      System.out.println("--- New RDD with "+rdd.partitions.size+" partitions and "+rdd.count()+" records")
      rdd.foreach(record => {
        println(record.value)
        val jedis = new RedisHelper().connecttoRedis()
        val parser: JsonParser = new JsonParser()
        val obj: JsonObject = parser.parse(record.value).getAsJsonObject()
        if (obj.has("v2")) {
          val obj2 = new RedisHelper().createJsonStringForRedis(obj,parser)
          jedis.lpush("obj2.get(SessionId).getAsString()+++++++++", obj2.toString)
        }
        else {
          println("No session ID... Data not stored in Redis")
        }
      }
      )
    })

    ssc.start
    ssc.awaitTermination*/
  }
}