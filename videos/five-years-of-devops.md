# GOTO 2014 • Five Years of DevOps: Where are we Now? • Michael T. Nygard

- <https://youtu.be/mFv5dcv7UzE>

## 1:00 - How did we get here?

The [DevOps] idea is around us for quite sometime.

predecessor | when
-|-
Agile Infrastructure | mid-2000s
Infrastructure as Code | early-2000s
Infrastructure 2.0 | early-2000s
cfengine (Mark Burgess) | 1993

Software dropped our provisioning time from order of days to order of minutes. (...) That's when DevOps really began to matter, when we cross that 1.0 threshold on infrastrucutre setup and delivery time.


## 6:18 - Michael T. Nygard journey

"Our software is only really interesting in production. And we should be getting at there better, faster and more reliably."


## 9:10 - DevOps name

Web Operations vs. Traditional IT Operations


## 10:25 - DevOps definition

John Willis - The Demings of DevOps

- CALMS:
    - Culture
    - Automation
    - Lean
    - Measurement
    - Sharing

They're in this order for a very important reason.

> Culture is the thing you have to get right first. If you don't have the right kind of culture, no amount of automation will really get you into a DevOps frame.

DevOps culture values fast feedback.

### Culture

- fast feedback
- direct connections
- data-based communication
- collaborative, low-ceremony
- enablement, not self-protection

about enablement and self-protection:

> I've been in a number of operations groups that have a very dim view of developers. They view developers and developer changes as the source of all of their pain. And so they try to protect themselves from that pain by erecting barriers.

The DevOps approach is inverted from that, in 2 ways:

- instead of building tools to automate operations job, we build tools to empower devs to do the operations job


> Whatever the solution is, the objective is the same:
> it's to get the human out of the loop. Use the human to apply knowledge and judgement in building the automation, not in executing the process every day or every week.

**DevOps culture is deliberately modeled in agile culture.**


### Automation

- lightweight tools, readiness to discard or change tools
- open source bias
- automate for leverage to change
- embrace & adopt "developer" tools
    - source control
    - code based configuration

> Underlying all of this is a shift in emphasis in the operations group from automation for self-preservation to automation for enablement of other people. Instead of making it easier for me to push the button, I'm gonna give you the button. Along with that, I'm gonna give you the consequences of pushing the button.

**DevOps is closing a feedback loop that's been broken for more than ten years.**

If you can create a problem and throw it over the wall and I have to suffer the consequences, two things happen:

1. I'm going to make the wall higher
2. You'll never learn how to stop creating problems

But if you create the problem and you're the one who gets the feedback on it, you're gonna learn how to stop creating problems.


### Measurement

- measure *everything*
- number of pizzas ordered by dev teams
    - could be leading indicator for turnover

**You find insight in unexpected places when you measure everything.**

A big risk in a growing and complex organization is **local optimization**.


Leverage Points in a System - Donella Meadows

#### Positive vs Negative feedback loops

> Positive feedback loops always win over negative feedback loops. If you're trying to drive a behavior out of a system, you can create a negative feedback loop, but you're a way better off creating a positive feedback loop to drive a more desirable behavior. The undesirable behavior will just fade out of existence when the desirable one takes over.


#### Structure of information flows

> If you don't believe me, put a monitor outside your CIOs office. I bet you that the number of the failed build goes down. Now maybe the number of builds total goes down, and size of the changes go up. So you have to be a little bit careful about what you reveal.

> Simply making information visible anywhere will cause people to try to change that information.

> If you make info visible, teach people how to react to it. Get away from notions of incentives or questions like that, just teach people "this is what normal looks like", "this is what bad looks like", "this is what better looks like". So everybody is moving in the same direction.

**If something hurts, you should do it more often.** (...) You'll get better at it, you'll find ways to make it not hurt, you'll find ways to automate it, rather than shying away from the pain.


### Human Factors and System Safety

- people are part of the system
- beware failure-inducing systems, unruly technology
- blameless post-mortems


## 33:45 - Where are we now?

Area | Grade
-|-
Deployment | A-
Provisioning | B
Logging | A+
Monitoring | A+
Anomaly Detection | C
System Comprehension | D+


### Antifragility - Systems That Improve From Randomness

- Deployments == downtime
- more deployments -> resilience to partial failure

reading suggested: effective web experimentation as a Homo Narrens - by Dan McKinley

https://mcfunley.com/effective-web-experimentation-as-a-homo-narrans

> I expect to see stories about how DevOps is failing, how companies are wasting money, how they had to roll it back. Because, if you're a journalist, that's the more interesting narrative now. It's not interesting to have another place that succeeds in doing something that other people have already done.


### Paradox of Automation

The more you automate something, the less prepared you are when it breaks.


### 50:05 - What's next?

