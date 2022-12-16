FROM node:6.14.2
EXPOSE 8080 80
COPY server.js .
CMD node server.js
