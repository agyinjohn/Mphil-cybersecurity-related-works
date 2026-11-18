---
title: "AN EXPLAINABLE SEMANTIC–BEHAVIOURAL HYBRID FRAMEWORK FOR SIEM-INTEGRATED DETECTION OF MULTI-TURN PROMPT INJECTION ATTACKS IN LARGE LANGUAGE MODEL APPLICATIONS"
subtitle: "A thesis submitted to the Department of Computer Science, Kwame Nkrumah University of Science and Technology, Kumasi, in partial fulfilment of the requirements for the award of the degree of MASTER OF PHILOSOPHY IN CYBERSECURITY"
author: "[STUDENT FULL NAME] (BSc. ...)"
date: "[MONTH], 2027"
---

# DECLARATION

I hereby declare that this submission is my own work towards the MPhil in Cybersecurity and that, to the best of my knowledge, it contains no material previously published by another person, nor material which has been accepted for the award of any other degree of the University, except where due acknowledgement has been made in the text.

| | | |
|---|---|---|
| [Student Name] ([Index No.]) | ……………………… | ……………… |
| Student | Signature | Date |
| **Certified by:** | | |
| [Supervisor Name] | ……………………… | ……………… |
| Supervisor | Signature | Date |
| **Certified by:** | | |
| [Head of Department] | ……………………… | ……………… |
| Head of Department | Signature | Date |

# DEDICATION

[To be written by the student.]

# ACKNOWLEDGEMENTS

[To be written by the student: God, supervisor(s), department, family, colleagues, sponsors.]

# ABSTRACT

*(Draft: complete the bracketed results after the simulation.)*

Large Language Models (LLMs) are increasingly embedded in enterprise systems, yet they remain vulnerable to prompt injection, the top-ranked risk in the OWASP Top 10 for LLM Applications. A recent SIEM-integrated framework combined Elastic SIEM correlation rules with a One-Class Support Vector Machine to bring LLM monitoring into Security Operations Centres (SOCs). However, that framework relies on post-generation behavioural features, has no semantic understanding of prompts, and was evaluated on single-turn, attack-heavy data that overstates operational performance. This study designs, implements and evaluates an explainable hybrid framework that fuses pre-generation semantic embeddings, gateway behavioural telemetry and session-level risk accumulation, and integrates them with a SIEM. The framework was evaluated on a corpus of [N] prompts, including [n] multi-turn attack sessions and [n] topic-matched hard benign prompts, at attack prevalence of [x %, y %, z %], and compared with re-implemented baselines, including a replica of the prior framework. The proposed framework achieved [F1 = …, recall = …, TPR@1 %FPR = …, PR-AUC = …] compared with [… for the baseline], detected [x %] of multi-turn attacks, and reduced false alerts to [… per 1,000 requests] with [… ms] added latency. Each alert carries SHAP-based explanations and MITRE ATLAS technique tags. The results show that [main conclusion]. The study offers SOC teams, particularly in regulated Ghanaian sectors, a practical path to monitoring generative AI systems.

**Keywords:** prompt injection; large language models; SIEM; security operations centre; anomaly detection; one-class SVM; multi-turn jailbreak; explainable AI.

# TABLE OF CONTENTS
[Generate automatically in Word: References → Table of Contents]

# LIST OF TABLES
[Generate automatically]

# LIST OF FIGURES
[Generate automatically]

# LIST OF ABBREVIATIONS

| Abbreviation | Meaning |
|---|---|
| AI | Artificial Intelligence |
| ASR | Attack Success Rate |
| ATLAS | Adversarial Threat Landscape for Artificial-Intelligence Systems |
| AUC | Area Under the Curve |
| CSA | Cyber Security Authority (Ghana) |
| ECS | Elastic Common Schema |
| FPR | False Positive Rate |
| IPI | Indirect Prompt Injection |
| LLM | Large Language Model |
| MTTD | Mean Time to Detect |
| OCSVM | One-Class Support Vector Machine |
| OWASP | Open Worldwide Application Security Project |
| PR-AUC | Area Under the Precision–Recall Curve |
| RAG | Retrieval-Augmented Generation |
| SHAP | SHapley Additive exPlanations |
| SIEM | Security Information and Event Management |
| SOAR | Security Orchestration, Automation and Response |
| SOC | Security Operations Centre |
| TPR | True Positive Rate |
