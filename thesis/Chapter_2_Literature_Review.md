# CHAPTER TWO

# LITERATURE REVIEW

## 2.1 Introduction

This chapter reviews the literature relevant to detecting prompt injection attacks in Large Language Model (LLM) applications. Section 2.2 explains the basic concepts of LLMs and how they are deployed in enterprises. Section 2.3 describes the prompt-injection threat and classifies the attacks. Section 2.4 reviews existing defences, grouped by where they act in the LLM pipeline. Section 2.5 reviews Security Information and Event Management (SIEM) systems and Security Operations Centre (SOC) practice. Section 2.6 reviews anomaly detection, focusing on one-class methods and their known problems in security. Section 2.7 discusses the benchmarks and evaluation methods used in this field. Section 2.8 reviews the base study by Alshammari and Alsaleh (2026) in depth. Section 2.9 considers the Ghanaian and African context. Section 2.10 presents a comparative summary of related works, Section 2.11 states the research gaps, and Section 2.12 presents the conceptual framework of the study.

## 2.2 Large Language Models and Enterprise Deployment

### 2.2.1 Overview of Large Language Models

LLMs are deep neural networks based on the transformer architecture. They are trained on very large text collections to predict the next token in a sequence. After pre-training, most commercial models are aligned with human preferences through instruction tuning and reinforcement learning from human feedback, so that they follow instructions and refuse harmful requests (Yao et al., 2024; Das et al., 2025). Small open-weight models such as Microsoft's Phi-3 Mini (Abdin et al., 2024) can run on a single GPU. This makes them attractive for organisations that want to keep data on their own premises, and for researchers who need controlled, repeatable experiments.

### 2.2.2 How LLMs Are Deployed in Organisations

In enterprises, an LLM rarely works alone. A typical **LLM-integrated application** has: (i) a **system prompt** written by the developer that defines the assistant's role and rules; (ii) **user input**; (iii) **retrieved context** from a Retrieval-Augmented Generation (RAG) pipeline, such as internal documents, e-mails or web pages; and (iv) optionally, **tools** the LLM can call, such as databases, e-mail APIs or code interpreters (Greshake et al., 2023; Liu et al., 2023). An **API gateway** usually sits between client applications and the model. It handles authentication, rate limiting and logging, and it is a natural place to collect security telemetry (Alshammari & Alsaleh, 2026; Maderamitla & Katragadda, 2026).

### 2.2.3 The Root Cause: No Separation Between Instructions and Data

Traditional software keeps code and data apart, for example through parameterised SQL queries. An LLM does not. The system prompt, user message and retrieved documents are all joined into one sequence of tokens, and the model has no built-in way to know which tokens are trusted instructions and which are untrusted data (Greshake et al., 2023; Chen et al., 2025). Every prompt-injection attack exploits this design weakness, which is why prompt injection is often compared to SQL injection (Willison, 2022; Liu et al., 2024).

## 2.3 Prompt Injection and Jailbreak Attacks

### 2.3.1 Definitions

**Prompt injection** is an attack in which adversary-controlled input causes an LLM to depart from the instructions of its developer or user (OWASP Foundation, 2025; Liu et al., 2024). **Jailbreaking** is a closely related attack in which the adversary tries to make the model ignore its safety training and produce restricted content (Wei et al., 2023). In practice the two overlap: many jailbreaks are delivered through injection, and many injections use jailbreak techniques. Following NIST (Vassilev et al., 2025) and most detection studies, this thesis treats both as malicious inputs that a detector should flag.

### 2.3.2 Taxonomy of Attacks

Table 2.1 classifies the main attack types discussed in the literature.

**Table 2.1: Taxonomy of prompt injection and jailbreak attacks**

| Category | Description | Representative works |
|---|---|---|
| Direct injection | The user types instructions such as "Ignore previous instructions and…" | Perez & Ribeiro (2022); Schulhoff et al. (2023) |
| Indirect injection (IPI) | Malicious instructions are hidden in content the LLM retrieves (web pages, PDFs, e-mails, tool outputs) | Greshake et al. (2023); Yi et al. (2025) |
| Role-play / persona jailbreak | The model is asked to adopt a persona without restrictions ("DAN", hypothetical scenarios) | Wei et al. (2023); Xu et al. (2024) |
| Obfuscation / token smuggling | Payloads are encoded (Base64, ROT13, leetspeak, Unicode) to avoid filters | Wei et al. (2023); Jain et al. (2023) |
| Optimisation-based suffix attacks | Automatically searched adversarial suffixes (e.g., GCG) that transfer across models | Zou et al. (2023); Wang et al. (2024) |
| LLM-generated (automated) attacks | An attacker LLM iteratively refines jailbreaks against a target | Chao et al. (2023); Mehrotra et al. (2024) |
| Multi-turn attacks | Harmless-looking turns gradually steer the model to harmful output | Russinovich et al. (2025); Anil et al. (2024) |
| Low-resource-language attacks | Harmful requests translated into languages poorly covered by safety training | Yong et al. (2023); Deng et al. (2024) |
| Agent / tool injection | Injected instructions cause an LLM agent to call tools for the attacker | Zhan et al. (2024); Debenedetti et al. (2024) |

**Direct injection.** Perez and Ribeiro (2022) showed that simple phrases such as "Ignore the previous instructions" could hijack GPT-3 applications ("goal hijacking") and leak their system prompts ("prompt leaking"). Large crowdsourced competitions such as HackAPrompt (Schulhoff et al., 2023) and Tensor Trust (Toyer et al., 2024) collected hundreds of thousands of human-written injection attempts. They showed that people find creative ways to bypass defences, and that a fixed list of known attacks quickly goes out of date.

**Indirect injection.** Greshake et al. (2023) showed that an attacker does not need to talk to the LLM at all: planting instructions in a web page or document that the application later retrieves is enough. They compromised real systems, including Bing Chat, and demonstrated data theft, phishing and worm-like spread. Yi et al. (2025) built the BIPIA benchmark and found that all tested LLMs were vulnerable, with attack success above 70 % on GPT-4 in some tasks. Indirect injection is especially dangerous in enterprises because input validation on the user's message never sees the malicious content (Chen, Y. et al., 2025).

**Jailbreaks and why safety training fails.** Wei et al. (2023) explained jailbreak success through two failure modes: *competing objectives*, where the model's drive to be helpful conflicts with safety, and *mismatched generalisation*, where safety training does not cover inputs such as encoded text that the model can still understand. Zou et al. (2023) showed that automatically optimised suffixes transfer from open models to commercial ones. Later work made automated attacks more efficient and harder to detect (Chao et al., 2023; Mehrotra et al., 2024; Wang et al., 2024; Huang et al., 2025). Xu et al. (2024) compared many attacks and defences and found that no defence was robust against all attack types.

**Multi-turn attacks.** Russinovich et al. (2025) introduced *Crescendo*, which starts with a harmless question and refers to the model's own previous answers to escalate gradually. Each message looks benign, so single-prompt detectors miss it. Anil et al. (2024) showed that filling a long context window with many fake dialogue examples ("many-shot jailbreaking") overcomes safety training, and that success grows with the number of shots. These findings matter for detection: **a detector that sees only one prompt at a time cannot see the attack**. Session-level analysis is needed.

**Low-resource languages.** Yong et al. (2023) translated harmful requests into low-resource languages such as Zulu and Scots Gaelic and bypassed GPT-4's safety filter far more often than with English. Deng et al. (2024) confirmed that safety performance falls as language resources decrease. This is directly relevant to Ghana, where users often mix English with Twi, Ga, Ewe, Hausa or Pidgin. No detection study reviewed here evaluates Ghanaian languages.

**Agents and tools.** When LLMs can act, injection becomes more dangerous. InjecAgent (Zhan et al., 2024) and AgentDojo (Debenedetti et al., 2024) showed that tool-using agents can be manipulated into transferring money, leaking data or deleting files through instructions hidden in tool outputs. Kang et al. (2024) showed that LLMs' programmatic abilities can be turned against them, much like classic security attacks.

### 2.3.3 Impact on Organisations

Successful prompt injection can lead to: (i) leakage of system prompts, credentials or customer data; (ii) generation of harmful or non-compliant content under the organisation's name; (iii) manipulation of decisions in automated pipelines; and (iv) unauthorised actions when LLMs have tool access (Greshake et al., 2023; OWASP Foundation, 2025). Alshammari and Alsaleh (2026) argue that an LLM agent with database write access should be treated like an application server: once compromised, it is a foothold for lateral movement. This justifies bringing LLM security into the SOC.

## 2.4 Existing Defences Against Prompt Injection

Defences can be grouped by where they act: (i) **prevention by design** (changing the model or prompt), (ii) **input-side detection** (inspecting the prompt before generation), (iii) **model-internal detection**, (iv) **output-side detection** (inspecting the response), and (v) **system-level monitoring**. Each group is reviewed below.

### 2.4.1 Prevention-by-Design Defences

**Prompt engineering.** Simple defences add warnings to the system prompt, wrap user input in delimiters, or repeat the instruction after the data ("sandwich defence"). Hines et al. (2024) proposed *spotlighting*, which marks or encodes untrusted data so the model can tell it apart from instructions, and reduced indirect-injection success substantially. Such defences are cheap but can be bypassed by attackers who adapt to them (Liu et al., 2024).

**Training-time defences.** StruQ (Chen et al., 2025) separates prompts and data into structured channels and fine-tunes the model to follow only instructions in the prompt channel. SecAlign (Chen, Zharmagambetov et al., 2024) uses preference optimisation for the same goal. OpenAI's *instruction hierarchy* trains models to give priority to system-level instructions over user and tool content (Wallace et al., 2024). These methods are promising but require access to model training. That is not possible for organisations using commercial APIs, and they still leave residual attack success.

**Randomised and certified defences.** SmoothLLM (Robey et al., 2025) perturbs the input several times and aggregates the responses, which defends against character-level suffix attacks. Semantic smoothing (Ji et al., 2025) extends this idea. *Erase-and-check* (Kumar et al., 2023) gives certified guarantees for some attack types. These methods multiply inference cost, which limits their use in interactive systems.

### 2.4.2 Input-Side Detection

**Keyword and rule filters.** The simplest detectors look for phrases such as "ignore previous instructions". They are fast and precise but easy to evade through paraphrasing or encoding (Jain et al., 2023). In Alshammari and Alsaleh (2026), a keyword filter achieved precision 0.988 but recall of only 0.540.

**Perplexity filters.** Optimised adversarial suffixes look like gibberish, so they have very high perplexity under a language model. Alon and Kamfonas (2023) and Jain et al. (2023) used perplexity thresholds to detect them. However, perplexity filters miss fluent, human-written attacks and can flag legitimate unusual text such as code or non-English input.

**Fine-tuned classifiers.** Several groups fine-tune transformer models to classify prompts as benign or malicious. Examples include PromptShield (Jacob et al., 2025), Meta's Prompt Guard (Meta AI, 2024), ProtectAI's DeBERTa-based classifier, and Rebuff (Protect AI, 2024), which combines heuristics, an LLM judge and a vector database of known attacks. Ayub and Majumdar (2024) showed that classical classifiers on top of sentence embeddings can also detect injections well. Supervised classifiers need labelled attack data and may not generalise to new attack styles (Arp et al., 2022). Jacob et al. (2025) noted that many earlier detectors had high false positive rates when tested on realistic benign data.

**LLM-as-judge and game-theoretic detection.** Llama Guard (Inan et al., 2023) uses a fine-tuned LLM to classify both prompts and responses against a safety taxonomy. DataSentinel (Liu, Jia et al., 2025) fine-tunes a detection LLM in a game-theoretic setup so that it stays robust to adaptive attacks. Such detectors are accurate but add the cost and latency of a second LLM call.

### 2.4.3 Model-Internal Detection

Attention Tracker (Hung et al., 2025) observed that when an injection succeeds, certain attention heads shift their focus from the original instruction to the injected one. It detects this "distraction effect" without training. Abdelnabi et al. (2025) detected *task drift* from changes in the model's internal activations before and after processing external data. These methods are elegant but need access to model internals, which commercial API deployments do not provide (Alshammari & Alsaleh, 2026).

### 2.4.4 Output-Side Detection

Output monitoring checks the model's response for policy violations, leaked secrets or signs of instruction-following (Inan et al., 2023). Alshammari and Alsaleh's (2026) OCSVM effectively belongs here, because most of its features (response entropy, refusal flag, latency) are measured on the response. Output detection catches attacks that input filters miss, but it acts only after the model has generated the harmful content. To *prevent* harm it has to hold back the response until the check is done, which adds latency.

### 2.4.5 System-Level Monitoring and Observability

A smaller body of work treats LLM security as a monitoring and observability problem. Chan et al. (2024) argued for visibility into AI agents through identifiers, real-time monitoring and activity logs. Maderamitla and Katragadda (2026) described privacy-safe telemetry and key performance indicators for LLM applications. Industry guidance from Google (Gavish, 2025) and Microsoft (MSRC, 2025) recommends layered defences that combine prevention, detection and impact limitation. Alshammari and Alsaleh (2026) are among the first to formally integrate LLM telemetry with a SIEM, and their work is the base for this thesis.

### 2.4.6 Synthesis of Defences

No single defence is sufficient. Prevention-by-design reduces but does not eliminate risk. Input classifiers need labelled data and miss new attacks. Model-internal methods need white-box access. Output methods act late. Most importantly, almost all of these defences inspect **one prompt or response at a time** and run **outside the SOC**. These observations support a **layered, SOC-integrated** approach that combines input-side semantic detection, behavioural telemetry and session-level correlation.

## 2.5 SIEM and Security Operations Centres

### 2.5.1 SIEM Fundamentals

A SIEM collects logs and events from across an organisation, normalises them into a common schema, stores them, and applies correlation rules and analytics to raise alerts (González-Granadillo et al., 2021). Common platforms include Splunk, IBM QRadar, Microsoft Sentinel, Wazuh and Elastic Security. The value of a SIEM lies in **correlation across time and sources**. One failed login means little; a hundred failed logins in a minute from one source point to a brute-force attack (Alshammari & Alsaleh, 2026). Elastic Security uses the Elastic Common Schema (ECS) to standardise fields, and its detection engine supports threshold, event-correlation (EQL) and machine-learning rules.

### 2.5.2 SOC Operations and Modernisation

A SOC is the team, processes and technology that monitor and respond to security incidents. Guidance from ENISA (2020), NIST SP 800-61r3 (Nelson et al., 2025) and CISA (2025) stresses centralised log collection, normalised data, correlation, automation through Security Orchestration, Automation and Response (SOAR) playbooks, and integration of incident response into organisational risk management. Giarimpampa et al. (2025) reviewed AI in security operations and concluded that automation should support, not replace, analyst judgement.

### 2.5.3 Alert Fatigue and the Base-Rate Problem

A major operational problem in SOCs is **alert fatigue**. In interviews with SOC analysts, Alahmadi et al. (2022) found that analysts see very high false positive rates, distrust tools that raise too many alerts, and value alerts that come with context and explanation. Axelsson (2000) showed mathematically that, because intrusions are rare, even a detector with a low false positive rate produces mostly false alarms (the **base-rate fallacy**). For LLM security this means that a detector evaluated on a dataset that is mostly attacks will look much better than it will perform in a real SOC, where most traffic is benign. Any LLM detector intended for SOC use should therefore be evaluated at realistic attack prevalence, with explicit estimates of alerts per day.

### 2.5.4 Threat Frameworks: MITRE ATT&CK and ATLAS

SOC analysts use MITRE ATT&CK to describe adversary tactics and techniques. **MITRE ATLAS** (Adversarial Threat Landscape for AI Systems) extends this to attacks on AI, including *LLM Prompt Injection* (direct and indirect), *LLM Jailbreak* and *LLM Meta Prompt Extraction* (MITRE, 2024). Mapping LLM alerts to ATLAS techniques lets analysts use familiar workflows and threat intelligence. None of the detection studies reviewed here, including the base study, map their alerts to ATLAS.

## 2.6 Anomaly Detection for Security

### 2.6.1 Overview

Anomaly detection identifies observations that differ significantly from normal behaviour (Chandola et al., 2009). It is attractive in security because it does not require examples of every attack: a model of "normal" can in principle flag new attacks. Methods include statistical tests, distance- and density-based methods such as Local Outlier Factor (Breunig et al., 2000), isolation-based methods such as Isolation Forest (Liu, Ting & Zhou, 2008), boundary methods such as One-Class SVM (Schölkopf et al., 2001), and deep methods such as autoencoders and Deep SVDD (Ruff et al., 2018).

### 2.6.2 One-Class Support Vector Machine

The OCSVM (Schölkopf et al., 2001) maps training data into a high-dimensional feature space using a kernel, typically the radial basis function (RBF), and finds a hyperplane that separates most of the data from the origin with maximum margin. Formally it solves:

$$\min_{\mathbf{w},\boldsymbol{\xi},\rho} \; \frac{1}{2}\|\mathbf{w}\|^2 + \frac{1}{\nu N}\sum_{i=1}^{N}\xi_i - \rho \quad \text{s.t.} \quad \mathbf{w}\cdot\phi(\mathbf{x}_i) \ge \rho - \xi_i,\; \xi_i \ge 0$$

where ν ∈ (0, 1] is an upper bound on the fraction of training points treated as outliers. The kernel width γ and ν strongly affect performance and must be tuned carefully. The OCSVM works well on small, low-dimensional data but scales poorly to very large datasets.

### 2.6.3 Known Limitations of Anomaly Detection in Security

Sommer and Paxson (2010) explained why anomaly-based intrusion detection rarely succeeds in practice: (i) the cost of errors is very high, (ii) "normal" traffic varies widely, (iii) there is a **semantic gap** between a statistical anomaly and a security-relevant event, and (iv) evaluation is hard. Arp et al. (2022) reviewed machine-learning security papers and listed common pitfalls, including **sampling bias**, **spurious correlations**, **inappropriate baselines**, **base-rate fallacy**, **lab-only evaluation** and **inappropriate threat models**. These pitfalls give a useful checklist for evaluating prompt-injection detectors. Section 2.8 shows that several of them apply to the base study.

Anomaly detectors also face **concept drift**: normal behaviour changes over time as users, prompts and models change (Gama et al., 2014). A one-class model trained on old benign traffic may raise false alarms on new legitimate usage, so drift monitoring and retraining policies must be evaluated, not only recommended.

### 2.6.4 Explainability

Security analysts need to know *why* a detector raised an alert. Model-agnostic explanation methods such as SHAP (Lundberg & Lee, 2017) attribute a prediction to input features. In a SOC, such explanations can be attached to alerts to support faster triage and build trust (Alahmadi et al., 2022). Explainability is rarely evaluated in prompt-injection detection research.

## 2.7 Benchmarks and Evaluation Practice

### 2.7.1 Datasets and Benchmarks

Several public resources exist for evaluating LLM attacks and defences:
- **Prompt-injection benchmarks:** Liu et al. (2024) formalised prompt injection and benchmarked five attacks and ten defences; BIPIA (Yi et al., 2025) for indirect injection; HackAPrompt (Schulhoff et al., 2023) and Tensor Trust (Toyer et al., 2024) for human-written attacks.
- **Jailbreak benchmarks:** JailbreakBench (Chao, Debenedetti et al., 2024) and HarmBench (Mazeika et al., 2024) provide standardised harmful behaviours and evaluation pipelines.
- **Agent benchmarks:** InjecAgent (Zhan et al., 2024) and AgentDojo (Debenedetti et al., 2024).
- **Domain datasets:** CySecBench (Wahréus et al., 2025) provides cybersecurity-focused malicious prompts.
- **Benign sources:** instruction datasets such as Stanford Alpaca (Taori et al., 2023).

Most of these are **single-turn**. Few public datasets contain realistic multi-turn attack sessions mixed with benign sessions, and none cover Ghanaian languages.

### 2.7.2 Evaluation Metrics

Common metrics include precision, recall, F1-score, false positive rate (FPR), area under the ROC curve (AUC-ROC), Attack Success Rate (ASR), and, for operational systems, detection latency or Mean Time to Detect (MTTD). For imbalanced settings, the area under the precision–recall curve (PR-AUC) and the true positive rate at a fixed low FPR (e.g., TPR@1 %FPR) are more informative than accuracy or AUC-ROC (Arp et al., 2022). Good practice also includes confidence intervals, statistical significance tests (e.g., McNemar's test for paired classifiers), ablation studies, and evaluation against **adaptive attackers** who know the defence (Tramèr et al., 2020).

## 2.8 Critical Review of the Base Study

Alshammari and Alsaleh (2026) proposed a three-tier hybrid framework: a gateway keyword filter, four Elastic SIEM correlation rules (keyword burst, refusal deviation, token spike, provenance anomaly) over a 60-second window, and an OCSVM (RBF kernel, γ = 0.1, ν = 0.05) on a seven-dimensional behavioural feature vector (tokens, response entropy, refusal flag, latency, keyword count, external classifier score, risk score). The OCSVM was trained on 1,200 benign interactions with a Phi-3 Mini gateway. The test set had 900 malicious prompts from CySecBench and 200 benign prompts from Stanford Alpaca. The full framework achieved precision 0.971, recall 0.810, F1 0.883, FPR 0.110, AUC 0.864, ASR 19.0 % and MTTD 2.3 s, against recall 0.540 for the keyword baseline.

**Strengths.** The study is one of the first to treat LLM gateways as monitored assets inside the SOC. It proposes a practical telemetry schema, keeps the LLM as a black box (so it suits API-only deployments), uses benign-only training to avoid the labelled-data bottleneck, and gives useful deployment guidance (shadow mode, phased rollout). The authors are also open about several limitations.

**Weaknesses.** Applying the pitfalls of Arp et al. (2022) and the operational concerns of Axelsson (2000) and Alahmadi et al. (2022) gives the following points:

1. **Post-generation features and ASR.** Most OCSVM features are computed on the model's response. The OCSVM can therefore only flag an attack after the harmful output exists, yet the study reports a reduction in ASR without explaining the blocking mechanism. Detection and prevention are conflated.
2. **Untested session-level claims.** The test data are single-turn, so the multi-turn detection capability, the main motivation for SIEM correlation, is not evaluated. The SIEM rules added only 81 true positives.
3. **Base-rate fallacy.** The test set is 81.8 % malicious. The paper estimates that an FPR of 0.110 at 10,000 queries per day gives about 110 false alerts per month. The correct figure is about 1,100 per day. At 1 % attack prevalence the expected precision falls to about 0.07.
4. **Sampling bias and spurious correlation.** Benign training data (gateway logs), benign test data (Alpaca, general topics) and malicious test data (CySecBench, cybersecurity topics) come from different sources. The detector may partly learn *topic* rather than *attack*. The paper reports that semantic mimicry, legitimate-looking security questions, is the main source of missed attacks.
5. **Limited rigour.** There are no confidence intervals, significance tests, feature ablations or alternative anomaly detectors; the hyper-parameters are fixed; and the ROC curves appear stylised (some fall below the chance line). The comparison with PromptShield, Prompt-G and Rebuff uses numbers reported in other papers rather than re-implementation on the same data.
6. **No adaptive-attack evaluation**, although the authors observed attackers deliberately lowering response entropy.
7. **No explainability, threat-framework mapping or privacy analysis**, despite claims of SOC-readiness and regulatory value.

These weaknesses do not make the study's contribution invalid. They define the research space this thesis addresses.

## 2.9 The Ghanaian and African Context

Ghana has a fast-growing digital economy, driven by mobile money, digital banking and e-government services (e.g., Ghana.gov and the Ghana Card identity system). Regulators have responded with the Data Protection Act, 2012 (Act 843), the Bank of Ghana Cyber and Information Security Directive (Bank of Ghana, 2018), and the Cybersecurity Act, 2020 (Act 1038), which established the Cyber Security Authority. Financial institutions and critical information infrastructure owners are required to maintain security monitoring, often through a SOC, and to report incidents.

As Ghanaian organisations adopt generative AI chatbots and assistants, prompt injection becomes a regulatory as well as a technical risk. A successful injection that leaks customer data could be a breach under Act 843. Two features of the local context make the problem harder. First, users often communicate in **local languages and code-switched English**, which existing detectors (trained mostly on English) are not designed for, and which are known to weaken LLM safety (Yong et al., 2023). Second, many organisations have **limited SOC staff and budgets**, so detectors must be lightweight and must not create excessive false alarms. To the best of the researcher's knowledge, no published study has evaluated prompt-injection detection for Ghanaian or African enterprise settings.

## 2.10 Summary of Related Works

**Table 2.2: Comparative summary of selected prompt-injection detection studies**

| Study | Approach | Stage | Session / multi-turn | SIEM / SOC integration | Unsupervised | Realistic base-rate eval. | Adaptive attack eval. | Explainable alerts |
|---|---|---|---|---|---|---|---|---|
| Alon & Kamfonas (2023) | Perplexity filter | Input | ✗ | ✗ | ✓ | ✗ | Partial | ✗ |
| Jain et al. (2023) | Perplexity, paraphrase, retokenisation | Input | ✗ | ✗ | ✓ | ✗ | ✓ | ✗ |
| Inan et al. (2023) – Llama Guard | LLM classifier | Input + Output | Partial (conversation) | ✗ | ✗ | ✗ | ✗ | Partial (category) |
| Hines et al. (2024) – Spotlighting | Prompt transformation | Prevention | ✗ | ✗ | n/a | ✗ | ✗ | ✗ |
| Chen et al. (2025) – StruQ | Structured fine-tuning | Prevention | ✗ | ✗ | n/a | ✗ | ✓ | ✗ |
| Robey et al. (2025) – SmoothLLM | Randomised smoothing | Input | ✗ | ✗ | n/a | ✗ | ✓ | ✗ |
| Jacob et al. (2025) – PromptShield | Fine-tuned classifier | Input | ✗ | ✗ | ✗ | ✓ (low-FPR focus) | Partial | ✗ |
| Hung et al. (2025) – Attention Tracker | Attention heads | Internal | ✗ | ✗ | ✓ | ✗ | Partial | ✗ |
| Abdelnabi et al. (2025) | Activation deltas | Internal | ✗ | ✗ | Partial | ✗ | Partial | ✗ |
| Liu, Jia et al. (2025) – DataSentinel | Game-theoretic detector LLM | Input | ✗ | ✗ | ✗ | ✗ | ✓ | ✗ |
| Protect AI (2024) – Rebuff | Heuristics + LLM + vector DB | Input | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| Alshammari & Alsaleh (2026) | Keyword + SIEM rules + OCSVM | Mostly output | Claimed, not tested | ✓ | ✓ | ✗ | ✗ | ✗ |
| **This study (proposed)** | Semantic + behavioural + session risk + SIEM | Input + Output | ✓ | ✓ | ✓ (with optional supervised) | ✓ | ✓ / Partial | ✓ |

*Note: "Partial" means the issue is discussed or partly evaluated. Verify each cell against the original papers before final submission, and adjust the last row to match what your simulation actually implements.*

## 2.11 Research Gaps

The review identifies the following gaps, which this study addresses:

1. **Gap 1 – Pre-generation detection in SIEM-integrated frameworks.** The only SIEM-integrated framework (Alshammari & Alsaleh, 2026) relies on post-generation behavioural features. It cannot block attacks before the response and has no semantic understanding of the prompt.
2. **Gap 2 – Evaluation of multi-turn attacks.** Multi-turn attacks are well documented (Russinovich et al., 2025; Anil et al., 2024), but SIEM-based session detection has not been evaluated on real multi-turn attack sessions.
3. **Gap 3 – Realistic, rigorous evaluation.** Existing evaluations use attack-heavy test sets, mismatched benign sources, literature-copied baselines and no significance tests, so they overestimate operational performance (Arp et al., 2022; Axelsson, 2000).
4. **Gap 4 – SOC-actionable explainability.** Prompt-injection alerts are not explained or mapped to MITRE ATLAS, which limits analyst trust and triage speed (Alahmadi et al., 2022).
5. **Gap 5 – Local context.** *(Optional, depending on simulation.)* Prompt-injection detection has not been evaluated for the Ghanaian enterprise context or for Ghanaian languages and code-switching.

## 2.12 Conceptual Framework

Figure 2.1 shows the conceptual framework of the study. User prompts and retrieved documents pass through an LLM gateway. **Before generation**, the gateway extracts semantic features (sentence embeddings) and lexical/behavioural features from the input and computes an input risk score. A **session-risk module** accumulates risk across the turns of a conversation. **After generation**, response features (entropy, refusal, length, latency) are added for output monitoring. All telemetry is sent in ECS format to the SIEM. There, correlation rules and the hybrid detector's scores are fused into alerts that carry SHAP explanations and MITRE ATLAS technique tags, and are passed to SOAR playbooks and analysts.

```
 User / RAG docs
       │
       ▼
 ┌──────────────── LLM Gateway ────────────────┐
 │  [Pre-generation]                           │
 │   • Semantic embedding  ─┐                  │
 │   • Lexical / keyword    ├─► Input risk ──┐ │
 │   • Prompt behaviour     ┘                │ │
 │                          Session risk ◄───┘ │──► BLOCK / ALLOW
 │  [LLM generation]                           │
 │  [Post-generation]                          │
 │   • Entropy, refusal, latency ─► Output risk│
 └──────────────────────┬──────────────────────┘
                        │ ECS telemetry (privacy-filtered)
                        ▼
              SIEM (correlation rules + score fusion)
                        │
                        ▼
     Explainable alert (SHAP + MITRE ATLAS tag) ─► SOAR / SOC analyst
```

**Figure 2.1: Conceptual framework of the study** *(redraw professionally in draw.io/Visio; adjust to match the implemented simulation)*

## 2.13 Chapter Summary

This chapter reviewed the literature on LLM prompt injection, existing defences, SIEM and SOC operations, anomaly detection, and evaluation practice. Existing defences are mostly stand-alone and single-prompt. The one SIEM-integrated approach relies on post-generation behavioural features and was evaluated under conditions that overstate its operational performance. The chapter identified gaps in pre-generation semantic detection, multi-turn evaluation, realistic and rigorous benchmarking, and SOC explainability, and presented a conceptual framework to address them. The next chapter describes the methodology used to design, implement and evaluate the proposed framework.
