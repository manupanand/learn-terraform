#frontend

docker run -d -p 80:80 -e CATALOGUE_HOST=catalogue.dev.manupanand.online \
 -e CATALOGUE_PORT=80 -e USER_HOST=user.dev.manupanand.online \
 -e USER_PORT=80 -e CART_HOST=cart.dev.manupanand.online -e CART_PORT=80 \
 -e SHIPPING_HOST=shipping.dev.manupanand.online -e SHIPPING_PORT=80 \
  -e PAYMENT_HOST=payment.dev.manupanand.online.com \
   -e PAYMENT_PORT=80 public.ecr.aws/w8x4g9h7/roboshop-v3/frontend

# catalogue
docker run -d -p 8080:8080 -e MONGO=true \
-e MONGO_URL="monogdb://mongo.dev.manupanand.online:27017/catalogue" \
public.ecr.aws/w8x4g9h7/roboshop-v3/catalogue
#catalogue-schema

docker run -e DB_TYPE=mongo -e APP_GIT_URL=https://github.com/roboshop-devops-project-v3/catalogue -e DB_HOST=mongo.dev.manupanand.online -e SCHEMA_FILE=db/master-data.js public.ecr.aws/w8x4g9h7/roboshop-v3/schema-load

# user

docker run -d -p 8080:8080 -e MONGO=true -e MONGO_URL="mongodb://mongo.dev.manupanand.online:27017/users" -e REDIS_URL="redis://redis.dev.manupanand.online:6379" public.ecr.aws/w8x4g9h7/roboshop-v3/user

# cart

docker run -d -p 8080:8080 -e CATALOGUE_HOST=catalogue.dev.manupanand.online -e CATALOGUE_PORT=80 -e REDIS_HOST=redis.dev.manupanand.online public.ecr.aws/w8x4g9h7/roboshop-v3/cart

# shipping

docker run -d -p 8080:8080 -e CART_ENDPOINT=cart.dev.manupanand.online:80 -e DB_HOST=mysql.dev.manupanand.online public.ecr.aws/w8x4g9h7/roboshop-v3/shipping

docker run -e DB_TYPE=mysql -e APP_GIT_URL=https://github.com/roboshop-devops-project-v3/shipping -e DB_HOST=mysql.dev.manupanand.online -e DB_USER=root -e DB_PASS=RoboShop@1 -e SCHEMA_FILE=db/app-user.sql public.ecr.aws/w8x4g9h7/roboshop-v3/schema-load

docker run -e DB_TYPE=mysql -e APP_GIT_URL=https://github.com/roboshop-devops-project-v3/shipping -e DB_HOST=mysql.dev.manupanand.online -e DB_USER=root -e DB_PASS=RoboShop@1 -e SCHEMA_FILE=db/schema.sql public.ecr.aws/w8x4g9h7/roboshop-v3/schema-load

docker run -e DB_TYPE=mysql -e APP_GIT_URL=https://github.com/roboshop-devops-project-v3/shipping -e DB_HOST=mysql.dev.manupanand.online -e DB_USER=root -e DB_PASS=RoboShop@1 -e SCHEMA_FILE=db/master-data.sql public.ecr.aws/w8x4g9h7/roboshop-v3/schema-load

# payment
docker run -d -p 8080:8080 -e CART_HOST=cart.dev.manupanand.online -e CART_PORT=80 -e USER_HOST=user.dev.manupanand.online -e USER_PORT=80 -e AMQP_HOST=rabbitmq.dev.manupanand.online -e AMQP_USER=roboshop -e AMQP_PASS=roboshop123 public.ecr.aws/w8x4g9h7/roboshop-v3/payment