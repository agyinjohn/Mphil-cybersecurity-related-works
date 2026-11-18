# CHAPTER THREE

# RESEARCH METHODOLOGY

> **Status:** skeleton. To be written in full once the simulation code and results are shared. Text in [brackets] marks what needs to come from the simulation.

## 3.1 Introduction
Overview of the design science research approach and chapter structure.

## 3.2 Research Design
- Design Science Research Methodology (problem identification → objectives → design → demonstration → evaluation → communication).
- Experimental, quantitative evaluation.

## 3.3 Experimental Environment
**Table 3.1: Hardware and software environment**: [CPU/GPU, RAM, OS, Python version, LLM(s) used, SIEM (Elastic/Wazuh/Splunk) version, libraries (scikit-learn, sentence-transformers, transformers, SHAP), etc.]

## 3.4 Dataset Construction
### 3.4.1 Malicious single-turn prompts: [sources, e.g., CySecBench, HackAPrompt, JailbreakBench, BIPIA; counts per category]
### 3.4.2 Indirect injection samples: [how payloads were embedded in RAG documents]
### 3.4.3 Multi-turn attack sessions: [how sessions were built, e.g., Crescendo-style escalation; number of sessions/turns]
### 3.4.4 Benign prompts, including hard benign (topic-matched security questions): [sources/counts]
### 3.4.5 Prevalence settings: [e.g., 50 %, 5 %, 1 % attack ratio]
### 3.4.6 Data splits and leakage control: [train / validation / test; benign-only training for one-class models]
**Table 3.2: Dataset composition**

## 3.5 Proposed Framework Design
### 3.5.1 Architecture overview (figure)
### 3.5.2 LLM gateway and telemetry schema (ECS field mapping table)
### 3.5.3 Feature engineering
- Semantic features: [embedding model, dimension, any reduction]
- Lexical/behavioural input features
- Output features (entropy, refusal, latency, length)
### 3.5.4 Detection models: [OCSVM / Isolation Forest / autoencoder / classifier; hyper-parameter search]
### 3.5.5 Session-risk module: [e.g., exponentially weighted cumulative risk, sliding window, CUSUM; equations]
### 3.5.6 SIEM correlation rules: [rule definitions; base-paper R1–R4 replica]
### 3.5.7 Decision fusion and alert generation (algorithm/pseudocode)
### 3.5.8 Explainability and MITRE ATLAS mapping
### 3.5.9 Privacy-preserving telemetry

## 3.6 Baselines
1. Keyword filter (Scenario A replica)
2. Base-paper replica: keyword + R1–R4 + OCSVM on 7 behavioural features
3. Perplexity filter
4. Open-source classifier(s) [e.g., Prompt Guard / ProtectAI DeBERTa], if used

## 3.7 Evaluation Metrics
Precision, recall, F1, FPR, AUC-ROC, **PR-AUC**, **TPR@1 %FPR**, ASR (with definition and how it is judged), MTTD/latency overhead, alerts per 1,000 requests. Equations for each.

## 3.8 Statistical Analysis
95 % bootstrap confidence intervals; McNemar's test between detectors; repeated runs with different random seeds; ablation study.

## 3.9 Adaptive Attack Evaluation (if done)

## 3.10 Ethical Considerations
Use of public datasets; no real user data; responsible handling of harmful prompts; no deployment against real systems.

## 3.11 Chapter Summary

---

# CHAPTER FOUR

# RESULTS AND DISCUSSION

## 4.1 Introduction
## 4.2 Dataset Statistics (descriptive results)
## 4.3 Replication of the Base Study (Scenarios A, B, C): compare with Alshammari & Alsaleh (2026) Table 2
## 4.4 Performance of the Proposed Framework (answers RQ1)
## 4.5 Multi-Turn Session Detection (answers RQ2)
## 4.6 Effect of Attack Prevalence and Alert Burden (answers RQ3)
## 4.7 Ablation Study
## 4.8 Latency and Resource Overhead
## 4.9 Explainability and SOC Alert Examples (answers RQ4)
## 4.10 Adaptive Attacks / Error Analysis
## 4.11 Discussion: link findings back to the literature in Chapter 2
## 4.12 Chapter Summary

---

# CHAPTER FIVE

# SUMMARY, CONCLUSIONS AND RECOMMENDATIONS

## 5.1 Introduction
## 5.2 Summary of Findings (one paragraph per specific objective)
## 5.3 Conclusions
## 5.4 Contributions of the Study (theoretical, methodological, practical)
## 5.5 Recommendations
- For SOC teams / organisations
- For regulators (CSA Ghana, Bank of Ghana)
- For LLM application developers
## 5.6 Limitations
## 5.7 Suggestions for Future Research
