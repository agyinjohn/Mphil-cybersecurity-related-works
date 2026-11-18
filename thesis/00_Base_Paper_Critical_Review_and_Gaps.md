# Critical Review of the Base Paper and Research Gap Analysis

**Base paper:** Alshammari, A. A., & Alsaleh, O. I. (2026). Detecting prompt injection attacks in generative AI systems: A hybrid SIEM and One-Class SVM framework. *Electronics, 15*, 2242. https://doi.org/10.3390/electronics15112242

**Purpose of this note:** a working document for the MPhil (Cybersecurity) thesis at KNUST. It (1) summarises the base paper, (2) checks its claims and numbers, and (3) lists research gaps that a thesis can address and defend in front of examiners.

---

## 1. Summary of the base paper

| Item | What the paper does |
|---|---|
| Problem | Prompt injection (OWASP LLM01) is detected by stand-alone, application-layer tools (PromptShield, Rebuff, Prompt-G, Attention Tracker) that are not connected to the enterprise SOC/SIEM and look at one prompt at a time. |
| Proposal | A three-tier hybrid: **(T1)** a gateway keyword filter → **(T2)** four Kibana/Elastic SIEM correlation rules over a 60-s window (R1 keyword burst, R2 refusal-rate deviation > 2σ, R3 token spike > 1.5× median, R4 provenance anomaly) → **(T3)** a One-Class SVM (RBF, γ = 0.1, ν = 0.05) on a 7-dimensional behavioural vector `[tokens, entropy, refusal, latency, keywords, external score, risk]`. Rule and OCSVM outputs are fused into Low/Medium/High alerts. |
| LLM | Phi-3 Mini Instruct behind an OpenAI-compatible gateway. |
| Training data | 1,200 "historical" benign interactions (source not described in detail). |
| Test data | 1,100 prompts: 900 malicious from CySecBench (180 each: direct injection, indirect injection, token smuggling, context hijacking, role-play jailbreak) + 200 benign from Stanford Alpaca. |
| Scenarios | A = keyword only; B = A + SIEM rules; C = B + OCSVM. |
| Headline results (C) | Precision 0.971, Recall 0.810, F1 0.883, FPR 0.110, ASR 19.0 %, AUC 0.864, MTTD 2.3 s. The OCSVM supplies 162 of the 243 extra true positives over the baseline. |
| Stated limitations | One model, small benign set, no inter-annotator agreement for ASR, no adaptive-attack evaluation, external baselines not re-implemented. |

## 2. Verification of the reported numbers

I recomputed the metrics from the confusion matrices (TP, FP, FN, TN):

| Scenario | TP | FP | FN | TN | Precision | Recall | FPR | Accuracy |
|---|---|---|---|---|---|---|---|---|
| A | 486 | 6 | 414 | 194 | 0.988 ✔ | 0.540 ✔ | 0.030 ✔ | 61.8 % ✔ |
| B | 567 | 14 | 333 | 186 | 0.976 ✔ | 0.630 ✔ | 0.070 ✔ | 68.5 % ✔ |
| C | 729 | 22 | 171 | 178 | 0.971 ✔ | 0.810 ✔ | 0.110 ✔ | 82.4 % ✔ |

The table values agree internally. The *interpretation* of them has problems, listed below.

## 3. Methodological weaknesses (the basis for your gaps)

### W1. Detection is mixed up with prevention (post-response features)
Four of the seven OCSVM features (response **entropy**, **refusal** flag, **latency**, and in part the risk score) exist only **after** the LLM has produced its answer. The paper notes that 74 % of OCSVM-only detections had response entropy > 4.2 bits and latency z > 1.8. So the OCSVM sees an attack only after the harmful output has been generated and possibly returned. Even so, the paper reports a 58.7 % drop in **Attack Success Rate**, which is a prevention metric. It never explains how a post-generation alert stops an attack that has already happened (e.g., by holding the response back). → **Gap: pre-generation (input-side) semantic detection that can block before generation, kept separate from post-generation output monitoring, with ASR measured honestly.**

### W2. The "multi-turn / session-level" claim is never tested
CySecBench and Alpaca are **single-turn** prompt collections. The paper does not say how prompts were grouped into sessions, so it is unclear how rules R1–R4 (60-s windows, rolling medians, session refusal rates) were exercised. Real multi-turn attacks such as Crescendo (Russinovich et al., 2025) and many-shot jailbreaking (Anil et al., 2024) are not in the test set. Session-level detection is the paper's central selling point, yet R1–R4 produced only 81 true positives. → **Gap: a real multi-turn / session attack dataset and a session-aware detector (e.g., cumulative risk or semantic drift across turns).**

### W3. Base-rate fallacy and an arithmetic error in the operational analysis
- The test set is **81.8 % malicious**, so precision (0.971) and accuracy are inflated. Real prompt-injection prevalence is far below 1 % of traffic (Axelsson, 2000; Arp et al., 2022).
- Section 8.3 says: *"At 10,000 queries per day, an FPR of 0.110 generates approximately 110 spurious alerts per month (~3.7 per day)."* The correct figure is 0.110 × 10,000 ≈ **1,100 false alerts per day** (~33,000 per month), about 300 times higher. At 1 % attack prevalence and recall 0.81, the expected precision would be 81 / (81 + 1,089) ≈ **0.07**. This is the "99 % false positives" situation SOC analysts complain about (Alahmadi et al., 2022).
→ **Gap: evaluate at realistic prevalence (e.g., 1 %, 5 %) and report precision–recall/PR-AUC, alerts per 1,000 requests, and analyst workload, not accuracy on an attack-heavy set.**

### W4. Distribution shift between training and test benign data
The OCSVM is trained on 1,200 benign gateway interactions of unspecified origin, but tested on Stanford Alpaca prompts, which are general instruction-following and not "legitimate cybersecurity queries" as the paper claims. The malicious set is cybersecurity-themed. A detector can then partly separate classes by **topic** rather than by **attack behaviour**. There are only 200 benign test prompts, so the 95 % CI on FPR = 0.11 is roughly [0.07, 0.16]. → **Gap: topic-matched hard benign samples (e.g., legitimate security questions such as "explain SQL injection"), which the paper itself names as the main cause of false negatives ("semantic mimicry").**

### W5. Weak experimental rigour
- **No statistical tests**: no confidence intervals, repeated runs, McNemar test, or bootstrap.
- **No ablation** of the seven features or of the fusion logic.
- **One anomaly detector**, with fixed hyper-parameters (γ = 0.1, ν = 0.05). Isolation Forest, LOF, autoencoder or Deep SVDD are not compared.
- The **ROC curves** (Fig. 5) look like smooth parametric curves, and Scenario A/B curves fall **below the chance diagonal** at high FPR. Curves from real data rarely look like this, so they appear illustrative rather than empirical.
- **External baselines were not re-implemented** (Table 3 copies numbers from other papers). Open detectors such as Meta Prompt Guard, ProtectAI's DeBERTa prompt-injection classifier, Llama Guard and perplexity filters could have been run on the same data.
→ **Gap: a reproducible, statistically sound, head-to-head benchmark.**

### W6. No semantic understanding
The paper admits that "semantic mimicry" and "response normalisation" (asking the model to answer in low-entropy text) defeat the behavioural features, and it lists a DistilBERT semantic layer as future work (§10, item 4). → **Gap: fuse lightweight semantic embeddings with behavioural telemetry (CPU-friendly, to keep latency low).**

### W7. No adaptive-attacker evaluation
The paper argues the OCSVM is hard to evade because attackers do not know the benign manifold, but this is not tested. The authors even saw attackers deliberately lowering entropy. Tramèr et al. (2020) show that defences claiming robustness must be tested against adaptive attacks. → **Gap: a white-/grey-box adaptive evaluation (e.g., entropy-shaping, paraphrase, and padding attacks).**

### W8. Indirect injection and agents are under-tested
The "indirect injection" samples come from CySecBench text, not real RAG documents or tool outputs. Agent benchmarks (InjecAgent, AgentDojo) and BIPIA are not used, and agentic LLMs are left to future work. → **Gap: real indirect injection in a RAG pipeline (poisoned documents) and/or tool-calling agents.**

### W9. SOC usability and explainability are claimed but not shown
The paper claims "decision provenance" but gives no feature attributions, no MITRE ATLAS / ATT&CK mapping, no Elastic Common Schema (ECS) field mapping, and no analyst evaluation. → **Gap: explainable alerts (e.g., SHAP), ATLAS technique tagging, and a small analyst usability study or alert-triage time measurement.**

### W10. Drift and retraining are recommended but not evaluated
Quarterly retraining and a "10 % drift" threshold are proposed without evidence. → **Gap: a concept-drift experiment (train on period 1, test on later or different-domain traffic).**

### W11. Privacy and regulation of prompt logging
Sending full prompts and responses to a SIEM creates a sensitive data store (PII, trade secrets). Hashing user IDs does not protect prompt content. → **Gap: privacy-preserving telemetry (redaction or feature-only logging) and compliance with Ghana's Data Protection Act, 2012 (Act 843) and Cybersecurity Act, 2020 (Act 1038).**

### W12. No multilingual or low-resource-language evaluation (high local relevance)
Low-resource languages bypass LLM safety training (Yong et al., 2023; Deng et al., 2024). Ghanaian enterprises (banks, MoMo operators, government e-services) serve users in English, **Twi, Ga, Ewe, Hausa and Ghanaian Pidgin**. Neither the base paper nor any prompt-injection detector I know of has been evaluated on these languages. → **Gap: a small Ghanaian-language prompt-injection test set and an evaluation of detector robustness to code-switching and translation attacks.**

---

## 4. Recommended thesis gaps (prioritised for MPhil scope)

Your thesis should **not** try to close all twelve gaps. A focused thesis that closes 3–4 of them properly is stronger. Here is a recommended core, with options:

| Priority | Gap | Why examiners will value it | Effort |
|---|---|---|---|
| **Core 1** | W1 + W6: pre-generation semantic + behavioural fusion | Fixes a logical flaw in the base paper and adds the semantic layer the authors asked for | Medium |
| **Core 2** | W2: genuine multi-turn session detection | Tests the base paper's central claim, which it never tested | Medium |
| **Core 3** | W3 + W4 + W5: realistic base-rate, hard-benign, statistically rigorous benchmark with re-implemented baselines | Gives you a methodological contribution even if accuracy gains are modest | Low–Medium |
| Option A | W9: explainable SOC alerts (SHAP + MITRE ATLAS + ECS) | Strengthens the cybersecurity/SOC angle | Low |
| Option B | W7: adaptive attacks | Strong security contribution | Medium |
| Option C | W12: Ghanaian-language robustness | Local relevance, novelty, fits KNUST | Medium (data creation) |
| Option D | W8: RAG/agent indirect injection | Topical | Medium–High |

## 5. Proposed thesis title options

1. **An Explainable Semantic–Behavioural Hybrid Framework for SIEM-Integrated Detection of Multi-Turn Prompt Injection Attacks in Large Language Model Applications**
2. Beyond Single-Prompt Detection: A Session-Aware, SIEM-Integrated Framework for Prompt Injection Detection Under Realistic Operating Conditions
3. Enhancing SOC Visibility into Generative AI Threats: A Hybrid Semantic and Anomaly-Based Prompt Injection Detection Framework with Low-Resource Language Evaluation

## 6. Draft research objectives

**General objective:** To design, implement and evaluate an explainable, SIEM-integrated hybrid framework that detects single-turn, multi-turn and indirect prompt injection attacks *before* LLM response delivery, under realistic operating conditions.

**Specific objectives:**
1. To critically analyse existing prompt-injection detection approaches and identify the limitations of behaviour-only, post-generation anomaly detection.
2. To build an evaluation corpus with (a) single-turn direct/indirect attacks, (b) multi-turn session attacks, and (c) topic-matched "hard benign" prompts, at realistic attack prevalence.
3. To develop a hybrid detector that fuses pre-generation semantic embeddings, gateway behavioural telemetry and session-level risk accumulation, integrated with a SIEM.
4. To compare the proposed framework with re-implemented baselines (keyword filter, base-paper OCSVM replica, perplexity filter, open-source transformer classifiers) using statistically sound metrics.
5. To evaluate the explainability, latency and SOC alert burden of the framework.

**Research questions:**
- RQ1: To what extent does adding pre-generation semantic features improve detection over behaviour-only OCSVM detection, especially for semantic-mimicry attacks?
- RQ2: Can session-level risk accumulation detect multi-turn attacks whose individual turns appear benign?
- RQ3: How do detection performance and alert burden change when attack prevalence falls from attack-heavy (≈80 %) to realistic (≤5 %) levels?
- RQ4: Can feature-attribution explanations and MITRE ATLAS mapping produce SOC-actionable alerts without unacceptable latency?

> **Note:** These objectives are a recommendation. Once you share your simulation, I will align the objectives, RQs and chapters with what you actually implemented and measured. A thesis must never claim more than its experiments show.
