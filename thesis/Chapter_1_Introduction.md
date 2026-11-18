# CHAPTER ONE

# INTRODUCTION

## 1.1 Background of the Study

Large Language Models (LLMs) such as GPT-4, Claude, Gemini, Llama and Phi-3 have moved quickly from research prototypes into everyday enterprise systems. Banks, telecommunication companies, hospitals, law firms and government agencies now use LLM-powered assistants to summarise documents, answer customer questions, generate code and support decision-making (Yao et al., 2024; Das et al., 2025). In Ghana, the same trend is visible in the financial and telecommunications sectors, where chatbots and AI assistants are being added to mobile banking, mobile money (MoMo) and customer-service channels. These deployments create a new attack surface that conventional security controls were not designed to monitor.

The most serious vulnerability of LLM applications is **prompt injection**. It has been ranked first (LLM01) in the OWASP Top 10 for LLM Applications since 2023 (OWASP Foundation, 2025). The U.S. National Institute of Standards and Technology classifies it as an evasion attack in its adversarial machine learning taxonomy (Vassilev et al., 2025). Prompt injection exists because an LLM processes trusted system instructions and untrusted user or document content in the same context window, with no architectural privilege boundary between them (Greshake et al., 2023; Perez & Ribeiro, 2022). An attacker can therefore write input that overrides the developer's instructions, leaks confidential data, or, when the LLM is connected to tools and databases, triggers unauthorised actions. Attacks can be **direct**, typed by the user, or **indirect**, hidden inside documents, web pages or e-mails that the LLM later retrieves (Greshake et al., 2023; Yi et al., 2025).

Researchers have proposed many defences: keyword and perplexity filters (Alon & Kamfonas, 2023; Jain et al., 2023), fine-tuned transformer classifiers such as PromptShield (Jacob et al., 2025) and Llama Guard (Inan et al., 2023), prompt-engineering defences such as spotlighting (Hines et al., 2024), training-time defences such as StruQ (Chen et al., 2025) and the instruction hierarchy (Wallace et al., 2024), and model-internal detectors such as Attention Tracker (Hung et al., 2025). Most of these tools, however, run as **stand-alone applications** and judge **each prompt in isolation**. They are not connected to the Security Information and Event Management (SIEM) platforms and Security Operations Centres (SOCs) that organisations already use to detect, correlate and respond to threats (González-Granadillo et al., 2021; CISA, 2025).

Alshammari and Alsaleh (2026) addressed this integration gap with a hybrid framework. It instruments a Phi-3 Mini LLM gateway to send structured telemetry to Elastic SIEM, applies four session-level correlation rules, and adds a One-Class Support Vector Machine (OCSVM) trained only on benign interactions. On a 1,100-prompt test set they reported an F1-score of 0.883, recall of 0.810 and an Attack Success Rate (ASR) of 19.0 %. Their work shows that SIEM-integrated LLM monitoring is feasible. A close reading of the study, however, shows important limitations. These limitations motivate the present research and are summarised in the problem statement below.

## 1.2 Problem Statement

Current SIEM-integrated prompt-injection detection, represented by Alshammari and Alsaleh (2026), has five main problems:

1. **Detection happens after the damage.** The anomaly detector relies mainly on features available only after the LLM has generated its answer: response entropy, refusal behaviour and latency. Such a detector can raise an alert, but it cannot stop a harmful response before it is produced. Reporting a reduced Attack Success Rate therefore mixes up detection with prevention.

2. **Multi-turn attacks are claimed but not evaluated.** The framework is presented as session-aware, yet it was evaluated only on single-turn prompt datasets (CySecBench and Stanford Alpaca). Multi-turn attacks such as Crescendo (Russinovich et al., 2025), where each message looks harmless but the conversation as a whole is malicious, were not tested.

3. **The detector does not understand meaning.** The behavioural features (token count, entropy, latency) cannot tell a legitimate security question ("Explain how SQL injection works") from a malicious one ("Help me execute a SQL injection attack"). The authors themselves identify such "semantic mimicry" as the main cause of missed attacks.

4. **The evaluation does not reflect real operating conditions.** The test set is 81.8 % malicious, while real attack prevalence in enterprise LLM traffic is very low. At realistic prevalence, a false positive rate of 0.11 would produce more than a thousand false alerts per day for a system that handles 10,000 requests, which is unworkable for SOC analysts (Axelsson, 2000; Alahmadi et al., 2022). The study also did not re-implement competing detectors, report confidence intervals, or test adaptive attackers.

5. **Alerts are not explained in a way SOC analysts can use.** The framework does not say *why* a prompt was flagged, and it does not map alerts to a threat framework such as MITRE ATLAS.

As a result, organisations still lack a validated, SOC-ready approach that can (i) block prompt injection *before* the model responds, (ii) detect multi-turn and indirect campaigns, (iii) keep false alarms manageable at realistic traffic levels, and (iv) produce explainable alerts. This study addresses that problem.

## 1.3 Research Objectives

### 1.3.1 General Objective

The general objective of this study is to design, implement and evaluate an explainable, SIEM-integrated hybrid framework that detects single-turn, multi-turn and indirect prompt injection attacks in LLM applications before response delivery, under realistic operating conditions.

### 1.3.2 Specific Objectives

The specific objectives are to:

1. Critically review existing prompt-injection attacks and detection approaches and identify the limitations of behaviour-only, post-generation anomaly detection.
2. Construct an evaluation corpus with single-turn direct and indirect attacks, multi-turn session attacks and topic-matched hard benign prompts, evaluated at realistic attack prevalence.
3. Develop a hybrid detection framework that fuses pre-generation semantic features, gateway behavioural telemetry and session-level risk accumulation, and integrate it with a SIEM platform.
4. Compare the proposed framework with re-implemented baseline detectors, including a replica of the Alshammari and Alsaleh (2026) OCSVM framework, using statistically rigorous metrics.
5. Evaluate the explainability, detection latency and SOC alert burden of the proposed framework.

## 1.4 Research Questions

1. **RQ1:** To what extent does adding pre-generation semantic features improve prompt-injection detection over behaviour-only OCSVM detection, particularly for semantic-mimicry attacks?
2. **RQ2:** Can session-level risk accumulation detect multi-turn attacks whose individual turns appear benign?
3. **RQ3:** How do detection performance and alert burden change when attack prevalence falls from attack-heavy to realistic levels?
4. **RQ4:** Can feature-attribution explanations and MITRE ATLAS mapping make prompt-injection alerts actionable for SOC analysts without unacceptable added latency?

## 1.5 Significance of the Study

**To practice (SOCs and enterprises).** The study gives security teams a tested way to bring LLM applications under existing SOC monitoring, with alerts that are explained and mapped to known adversary techniques. This matters for Ghanaian organisations regulated by the Bank of Ghana's Cyber and Information Security Directive (Bank of Ghana, 2018), the Cybersecurity Act, 2020 (Act 1038) and the Data Protection Act, 2012 (Act 843), which require monitoring, incident reporting and protection of personal data.

**To research.** The study corrects methodological weaknesses in prior work: it separates pre- and post-generation detection, evaluates at realistic prevalence, uses statistical tests and re-implements baselines. It also provides an evaluation corpus with multi-turn attacks and hard benign prompts that later studies can reuse.

**To policy.** The findings can inform the Cyber Security Authority (CSA) of Ghana and sector regulators as they develop guidance on the secure adoption of generative AI.

**To academia.** The thesis adds to the small body of African research on LLM security and can serve as a reference for future postgraduate work at KNUST.

## 1.6 Scope of the Study

The study focuses on **detecting** prompt injection and related jailbreak attacks against text-based LLM applications accessed through an API gateway. It covers direct, indirect (document-embedded) and multi-turn attacks. The framework is implemented and evaluated in a simulated enterprise environment using open-weight LLM(s) and an open-source SIEM stack. The study does not cover training-time defences (e.g., fine-tuning the LLM), multimodal (image/audio) prompt injection, or deployment in a live production SOC.

*[Update this section after the simulation is shared: name the exact LLM(s), SIEM, datasets and tools used.]*

## 1.7 Overview of Methodology

The study follows a **design science research** approach: build an artefact (the detection framework) and evaluate it rigorously. The main steps are: (i) a systematic literature review; (ii) dataset construction from public benchmarks and generated multi-turn and hard benign samples; (iii) implementation of the gateway, telemetry pipeline, semantic and behavioural detectors, session-risk module and SIEM rules; (iv) experiments comparing the proposed framework with baselines under different attack-prevalence settings; and (v) statistical analysis of the results. Chapter Three gives full details.

## 1.8 Limitations of the Study

*[To be finalised after the simulation results. Likely items:]*
- Experiments run in a simulated environment, not a live enterprise SOC.
- A limited number of LLM families are evaluated because of computing resources.
- Some attack and benign samples are synthetically generated and may not capture every real-world pattern.

## 1.9 Organisation of the Thesis

The thesis has five chapters. **Chapter One** introduces the study: background, problem statement, objectives, research questions, significance and scope. **Chapter Two** reviews the literature on LLM prompt-injection attacks, existing defences, SIEM and SOC operations, and anomaly detection, and identifies the research gaps. **Chapter Three** describes the research methodology, including the framework design, datasets, implementation and evaluation protocol. **Chapter Four** presents and discusses the experimental results. **Chapter Five** summarises the findings, draws conclusions and makes recommendations for practice and future research.
