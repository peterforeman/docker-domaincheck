"use strict";
const whois = require("whois-json");
const nodemailer = require("nodemailer");

// DOMAINS = domain,domain,domain
// SLEEP = 86400
// SMTP_FROM "Fred Foo 👻" <foo@example.com>
// SMTP_TO bar@example.com, baz@example.com
// SMTP_HOST

async function sendMail(domain: string) {
  console.info(`Sending mail for domain ${domain}`);

  // create reusable transporter object using the default SMTP transport
  let transporter = nodemailer.createTransport({
    host: process.env["SMTP_HOST"] || "localhost",
    port: process.env["SMTP_PORT"] || 25,
    secure: process.env["SMTP_PORT"]
      ? parseInt(process.env["SMTP_PORT"]) == 465
      : false, // true for 465, false for other ports
    auth: {
      user: process.env["SMTP_USER"] || "",
      pass: process.env["SMTP_PASS"] || "",
    },
    tls: {
      rejectUnauthorized: false,
    },
  });

  if (
    !process.env["SMTP_FROM"] ||
    !process.env["SMTP_HOST"] ||
    !process.env["SMTP_TO"]
  ) {
    console.error(`Not all SMTP settings defined`);
    return;
  }

  try {
    // send mail with defined transport object
    let info = await transporter.sendMail({
      from: process.env["SMTP_FROM"] || "domaincheck@localhost",
      to: process.env["SMTP_TO"] || "",
      subject: `Domaincheck: ${domain} is free!`,
      text: `Domaincheck: ${domain} is free!`,
    });

    console.info(`Mail sent: ${info.messageId}`);
  } catch (e) {
    console.error(e);
  }
}

async function checkDomains(domains: Array<string>) {
  console.info(`Starting run, checking ${domains.length} domains`);

  for (let x: number = 0; x < domains.length; x++) {
    let domain = domains[x];
    let results = await whois(domain);
    if (
      !results.domainName ||
      results.domainName.toLowerCase() != domain.toLowerCase()
    ) {
      console.info(`Domain ${domain} is free`);
      sendMail(domain);
    } else {
      console.info(`Domain ${domain} is taken`);
    }
  }

  console.info(`Run done`);
}

let sleepTime: number = process.env["SLEEP"]
  ? parseInt(process.env["SLEEP"])
  : 86400;
let domains: Array<string> = (process.env["DOMAINS"] || "")
  .toLowerCase()
  .split(",");

if (domains.length == 1 && domains[0] == "") {
  console.error(`Define domains in environment variable DOMAINS!`);
  process.exit(1);
}

if (!process.env["SMTP_HOST"]) {
  console.warn(`SMTP_HOST not set, mailing disabled`);
}

setInterval(() => {
  checkDomains(domains).catch(console.error);
}, sleepTime * 1000); // every 24 hours

// Initial
checkDomains(domains).catch(console.error);

// whois $element | egrep -q '^No match|^NOT FOUND|^Not fo|AVAILABLE|^No Data Fou|has not been regi|No entri|is free'
