---
layout: post
title: "The best way for programmers to interview programmers"
date: 2014-01-24 05:56:52 +0900
comments: true
published: true
categories: [HowTo, Interviewing]
keywords: "interviews, programming"
description: "the best way for a programmer to interview another programmer"
---

**Every programmer should know how to give technical interviews.** Although you will rarely be judged on your interviewing abilities, it is definitely in your best interest to help ensure your company is hiring effective programmers. If you manage to surround yourself with great programmers you'll foster a much better environment in which you can become a great programmer yourself. If you find yourself surrounded by programmers you consider sub-par you'll end up supporting their crappy software.

{% pullquote right %}
I have been interviewing programmers for many years and reckon {" the best way to find great programmers is by giving them some control over the interview topic, and then going deep into a few questions instead of broad across many topics "}. This takes a lot of guts however - it requires the interviewer to pay attention, and ideally (though not necessarily) to have a fairly broad knowledge base themselves.
{% endpullquote %}

I believe this advice applies to all programmers - of course interviewing is rarely in your job description, but it is definitely in your best interest to make sure interviews get done well at your company. Unfortunately most companies will allow anyone to interview and won't have a good way to tell that they're not doing it well, ultimately damaging the work environment.

<!-- more -->

## The mediocre way

Typically interviewers will be given a list of questions to ask and some criteria by which to judge the answers to these questions. Perhaps the interview will follow some format of scripted grilling, perhaps a practical section, and some kind of open two-way forum. Following a script is supposed to allow the candidates to be compared fairly on a level playing field. The practical section might consist of taking apart a printed code sample or even writing some code, and the forum provides the candidate the opportunity to explain their situation and determine if they actually want to work at the company themselves.

This has a lot of problems however:

- if the interviewer completely controls the questions the candidate may come across poorly because they don't happen to have experience in the specific fields chosen, or because he or she is just very nervous
- it promotes a one-size-fits-all mentality, which will lead to a homogenous work environment
- it is too easy for the interviewer to just phone it in without truly probing for deeper knowledge. In fact this becomes more likely as the interviewer becomes bored of the questions
- it is too easy for candidates to blag - some people can sound like experts when all they have is brash confidence and a few keywords. Plus, recruitment companies often coach candidates on what questions might be asked so those keywords are likely to be there
- quiz-type interviews often fail to test higher-level proficiencies, such as communicating architecture and design information

I think it's well worth throwing away the 'standardised' approach to testing technical capabilities. There is too much risk of false negatives _and_ false positives along this approach - a poor programmer may have been well coached, and a good programmer might have an unfortunate gap right where your questions probe (surely I could have worded that better...) 

## The Seshbot way

While it is important to cover several bases in an interview, the most important question I always ask is **'what was the most recent interesting project in which you were heavily involved?'** I almost always spend most of the interview going deep into a few questions that branch off the answers to this question.

{% pullquote right %}
This question puts the ball firmly in the candidate's court, and largely eliminates the problems outlined above. {" If a programmer can't talk throughly about a topic about which they chose themselves and are purportedly very interested, they probably aren't right for the job "} (at whatever company I'm working for anyway!)
{% endpullquote %}

Once the candidate has explained the project, the interviewer can then challenge the details of that project as a way of testing the candidate's knowledge of that system and the reasoning behind its design. The types of question would vary depending on the workplace, but at my last job for example I probably would have asked:

- <em>architecture:</em> please outline for me (ideally on a whiteboard or paper) how the whole system hangs together. I might expect the candidate to talk about the systems involved, data flows, security considerations, or data storage and integrity for example.
- <em>design quality attributes and compromises:</em> how does this system provide, or how would you adjust this architecture to provide, various quality attributes (high availability, reliability, scalability, performance, security)? What compromises would these changes entail?
- <em>design:</em> if I were a new developer working on this team, how would you describe the design of this system to me?
- <em>specifics:</em> I also spend a lot of time asking 'what is the purpose of that service/component/class'

<span style="color: green; font-weight: bold;">Pros:</span> This addresses all of the problems I outlined with the more traditional approach:

- the candidate is talking about something they are presumably proud of and know inside-out. If they can't talk happily on this subject they won't be able to talk about any subject
- the candidate is more able to show you what their particular skill set entails, and what they believe is their forte without them awkwardly spelling it out (through stupid 'what are your strengths and weaknesses' questions)
- the interviewer must be engaged in the process in order to ask relevant questions. It is in fact a great way to keep the interviewing process more interesting - and even educational - for the interviewer
- because it is a 'deep' and detailed question, it is very difficult to blag. Someone might be able to re-draw arcitectural diagrams they had to become familiar with in the past, but they would still need to know _why_ the system was configured that way to answer the questions
- the test focuses on communication of ideas, which I believe is the most important skill for a team member to have. You may or may not agree with this, but you certainly want to have tested it

<span style="color: red; font-weight: bold;">Cons:</span> There are some caveats however:

- do not let the candidate run the interview. It can be too easy to tackle a question by diverting into another topic - make sure that the candidate answers the questions you ask to your satisfaction
- keep an eye on the time, because although you want to go deep on few questions, there's no point going deeper into a topic once the candidate has demonstrated their knowledge in that area
- it can be difficult to recall what you discussed later when you're trying to make a decision about the candidate. Take notes constantly, and summarise the interview in an email directly after you finish it
- if the candidate chooses to talk about technologies with which you're not very familiar yourself you'll be forced to ask largely high-level questions. This is not terrible as I believe you can still figure out if they know their stuff, but you might end up having to take their word on a few things

## How to measure success

Other than retention rates I am not certain of how to measure if your technique is successful, but in my experience most prospective programmers in the job market are not very good (something like 1-in-10), and so if you're hiring a high percentage of applicants you're probably letting in a few duds. 

This might seem depressing and I feel bad about saying that, but this is my blog and I want to put my honest opinion up here. Take it as you will. [Others agree with me](http://www.codinghorror.com/blog/2007/02/why-cant-programmers-program.html) however.

Because of this it is a very good idea to have a basic pre-screening done before the proper interview. It should be very simple and not take too long - a simple test should be sufficient to weed out most of the poor programmers, and you need to remain respectful of the candidate's time as they are interviewing _you_ as well. 

## What about live coding?

Here's an anecdote: once while applying for a job at a large investment bank I was given an almost purely practical interview. On arriving I sat down with the lead developer and chatted for a bit before heading into the programming room to do some pair programming. Sweet right?

Anyway I sat at this Windows box with Visual Studio on it (this was for a largely .Net job) and was given the basic [fizzbuzz test](http://c2.com/cgi/wiki?FizzBuzzTest). There is a lot of controversy around this interview technique but I actually enjoy practical questions so didn't have a problem with the idea. The interview was a shambles however, and although I did well I count it as a terrible interview that did not serve its purpose at all. 

First I had trouble with their development environment. The machines at this bank were ridiculously slow - they were running a special (presumably super-secure) build of Windows 95 that was by now literally something like 13 years old, and they couldn't change because it would be too costly to get a special build of a more modern Windows. So we sat there for a long time waiting to get all the software up and running, and every button click seemed to require the human genome to be re-calculated.

The next problem was that making sure that the interviewer and I were on the same page took way too long. I did the fizz-buzz program, and decided to show him how I would do it declaratively (with LINQ) so we could talk about the benefits of declarative programming. Of course if I were interviewing someone I would want them to solve the problem as simply as possible first, then make it more complicated later. I know through experience that many candidates think that they are expected to say things like _I would never start programming without a firm set of requirements!_ or some other approach showing that they know about all areas of software development. 

Turns out this guy wanted me to demonstrate some test-driven development, and so was expecting me to have started by writing tests. So OK, I figured I'd download [SpecFlow](http://www.specflow.org/) because I had used it successfully recently and really liked it. But no, this is a bank I'm sitting in so we can't just download stuff - things have to go through a days-long process of scanning and justification before new software is installed. So I ask what they use and he mentioned some package or other. So I had to read the docs on that, and we had trouble actually running it on this machine in the end because we had to configure some directories in Visual Studio or something, and much more time was wasted.

I'm not saying it can't work, but in my opinion live coding is fraught with dangers. A much better alternative is to browse the applicant's source code online for projects they have worked on. Realistically though the number of people I have interviewed that had  online code I could evaluate was exactly 1 (I did hire him though!)

## General interviewing advice

Obviously interviewing is a difficult thing to do well. You have a small amount of time to decide whether to commit your company to filling a permanent seat on your team, which is a _huge_ deal. Probably practice is the only thing that helps mitigate this (and the Seshbot technique of course) but here's a few other pointers that come to mind:

- <em>take notes constantly!</em><br />One of the problems you can encounter with a less scripted interview is that when summarising how the interview went, it can be difficult to recount all the things you talked about. I tend to fill a couple of pages in my notebook with bullet-pointed scribbles during each interview
- <em>know when you know</em><br />The best interview I ever gave was a really nice guy called Phil. Only a few minutes into the interview I realised that he had probably handled my questions better than I could have. So I just sat back and told him 'I don't think we really need to go any further', then I walked out and asked HR to give him an offer on the spot. I was always happy that I did that.
- <em>do basic screening</em><br />If no screening has been performed it is worthwhile asking a couple of basic language-specific technical questions to make sure you're not wasting your time
- <em>the interviewer doesn't need to know the answer to all the questions he or she asks</em><br />You can choose to pretend that you really know and are just testing their knowledge, but if I don't know something I usually don't mind asking questions in an outright manner - there's no need to maintain a facade of superiority and being honest helps promote a candid atmosphere
- <em>have a standard approach to summarising the interview</em><br />At the end of the day you need to provide some quantifiable metric by which to decide who to hire. Plus HR and the recruiter usually require some specific information. At my last place HR was happy with just the name, date, my decision/recommendation, and justification for that decision
- <em>if you're doing a phone interview (unfortunate!) follow a script for the scaffolding for the interview</em><br />This keeps you from spending too much time on the plesantries and keeps you from waffling on
- <em>I usually like to ask if there's any good books a person would recommend, and ask what they got from it</em><br />It may be curmudgeonly of me but I don't think a person can learn fundamentals very well from Stack Overflow alone
- <em>Work with your recruiter, but assume they are coaching the candidates</em><br />A cool side-effect of this techinique is that it doesn't matter if candidates are coached - I told our recruitment agencies to feel free sharing information about our interviews with candidates
