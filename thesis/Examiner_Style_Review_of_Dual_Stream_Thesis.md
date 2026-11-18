# Examiner-Style Review: *Dual-Stream Prompt Injection Detection for LLM Gateways*

**Candidate:** John Agyin. **Supervisor:** Prof. F. Twum. **Reviewed version:** 58-page PDF dated 27 Oct 2026.
**Purpose:** find what an internal or external examiner is likely to challenge, before submission. Issues are ranked by how much they could change results or the viva outcome.

---

## 1. Overall assessment

This is a strong MPhil thesis. It replicates the base paper independently, controls leakage, applies paired significance tests and prevalence-adjusted precision, and reports its negative results honestly (fixed fusion is worse than Stream B; Stream B collapses on unseen families). That puts it above most published work in this area. The research questions follow from clearly stated gaps, every RQ is answered in Chapter 5, and the recommendations (tiered alerting) follow from the evidence.

**Numbers verified.** I recomputed every confusion-matrix metric (Tables 4.1, 4.3, App. C), every McNemar χ² and its consistency with the confusion matrices (b − c equals the difference in correct counts in all five comparisons), every prevalence-adjusted precision (Table 4.9, eq. 2.2), the ASR reductions, the session-coverage percentages, and the corpus totals (Table 3.1: 9,346 + 3,835 = 13,181; 4,200 benign train; 2,042 / 642 / 1,793 test). **All are internally consistent.** I found no arithmetic errors. Every in-text citation has a reference entry, and the figures look like genuine plots from data.

The remaining issues are about **validity of the simulation design**, **wording of claims**, and **presentation**.

---

## 2. Critical issues (could change results; fix or explicitly address)

### C1. Session construction may inflate the SIEM-rule results
**Where:** §3.4 ("Sessions and risk"), §3.6, Tables 4.1–4.2, 4.8.
Sessions are **homogeneous**: benign prompts are grouped into benign sessions and attacks into attack campaigns. Two parts of the pipeline use session history:
- **Rule R2** (session refusal rate) flags *every prompt in a session* once the session's refusal rate exceeds baseline. In an all-attack session, one refusal can label compliant attack turns as detected too.
- **Stream A's `x_risk` feature** is the fraction of prior turns with an override keyword. In a homogeneous attack session, this is effectively a class label passed between turns.

This could explain why, in your replication, **the rules contribute 971 extra true positives while the OCSVM adds only 109**. That finding is one of your headline contributions, so an examiner will ask whether it reflects the rules or the session grouping.

**Fixes:**
1. State explicitly whether rules are evaluated **causally**, i.e., a rule can flag only the turn on which it fires and later turns, never earlier ones. If not, make them causal.
2. Add a **sensitivity run** with (a) singleton sessions (no history) and (b) **mixed sessions** where 1–2 attack turns are inserted into otherwise benign sessions, which is closer to real attacker behaviour. Report Table 4.1/4.2 for each. If the rules' share drops sharply, say so: it is still a finding.
3. Add this to the threats-to-validity paragraph in §4.11.

### C2. Response-pool provenance may act as a class signal for Stream A
**Where:** §3.2 (last paragraph), §3.4.
Benign responses come from **Alpaca outputs** (text-davinci-003) or BIPIA reference answers. Attack responses come from **JailbreakBench/HarmBench generations** (Vicuna, Llama-2, GPT-3.5/4). Response features such as entropy (4.09 vs 4.39 bits), completion length and refusal phrasing may therefore partly encode *which model or dataset produced the text* rather than *whether the prompt was an attack*. This is the "spurious correlation / sampling bias" pitfall from Arp et al. (2022), which you cite against Stream B but not here.

**Fixes:**
1. State whether the response pools are **split into train and test** draws. If the same Alpaca outputs can appear in both OCSVM training and test benign telemetry, say so and fix it.
2. Add a short table of entropy and completion length **per response pool** (Alpaca, BIPIA, JBB-compliant, JBB-refusal, HarmBench) so readers can see the confound's size.
3. Add the confound to §4.11 and §5.5 as a threat to internal validity.

### C3. "Family-agnostic" overstates Stream A
**Where:** Abstract, §4.8, §4.11, §5.1 (finding 5), §5.2 (RQ5), §5.3 (contribution 4).
Stream A is trained on benign data only, but two of its features (`x_keywords`, and `x_risk` derived from it) use an **override-phrase regex written from known attacks** ("ignore previous instructions", "DAN", "developer mode", ...). Its 1.000 recall on "unseen" direct injection in the leave-one-family-out (LOFO) test comes mostly from this signature, so that family is not truly unseen by Stream A's design. An examiner will ask: *"Is Stream A detecting novel behaviour, or matching keywords you chose?"*

**Fixes:**
1. Rerun the LOFO direct-injection row for **Stream A without `x_keywords` and `x_risk`** (you already have the ablation code).
2. Change the wording from "family-agnostic" to: *"requires no labelled attacks and no retraining; its behavioural features are independent of the attack families in the training data, although its keyword feature encodes prior knowledge of override phrasing."*

### C4. Small leakage in learned-fusion training
**Where:** §3.9.
You correctly use out-of-fold p_B. But Stream A's scores on **benign training** prompts are **in-sample**, because the OCSVM was fitted on them. These benign scores will look more "normal" than benign test scores, so the combiner sees a cleaner separation for Stream A than exists at test time. The direction of the bias is uncertain and the effect is probably small (the combiner already down-weights Stream A), but the fix is cheap.

**Fix:** fit the OCSVM in k folds on the benign training set and use out-of-fold s_A for benign training rows. Rerun E2/E4/E7 and report any change, even if it is "no material change".

---

## 3. Major issues (framing, claims, chapter scope)

### M1. "Semantic" describes a lexical model
Stream B is TF-IDF word and character n-grams with logistic regression. That is a **lexical** text classifier, and examiners in NLP or security will note that it does not model meaning. Your own §4.8 and §4.9 results (it collapses on unseen families and on obfuscation) are the behaviour one expects from a lexical model. The title also contains "Semantic Intent Classification".

**Options (best first):**
1. **Add a transformer or embedding stream** (DistilBERT/DeBERTa-v3 fine-tuned, or a sentence-embedding model plus logistic regression) as Stream B′. Even one extra row in Tables 4.3, 4.12 and 4.13 would turn your stated main limitation into a result. *Hugging Face downloads are blocked both in your earlier environment and in this cloud session (proxy 403). Kaggle or Google Colab, which have HF access and free GPUs, would work. Alternatively I can request network access to `huggingface.co` for this session, which you would need to approve.*
2. Otherwise rename it consistently, e.g., "**text-based intent classifier**" (Stream B: lexical intent classifier), and justify in §2.6 why a lexical model is a meaningful lower bound.

### M2. Claims about SIEM integration and realistic prevalence
Table 2.1 marks "This thesis" as **Yes** for "SOC/SIEM integration", "Session context" and "Tested at realistic prevalence". But no SIEM was deployed (rules are KQL-style specifications evaluated in Python), sessions are synthetic, and realistic prevalence is an **analytical adjustment** (eq. 2.2), not a test on low-prevalence traffic.
**Fix:** change these cells to "Designed (ECS schema, KQL rules; simulated)", "Simulated sessions" and "Prevalence-adjusted". Consider "**under Prevalence-Adjusted Evaluation**" in the title, or keep the title and make the abstract precise.

### M3. Define "prompt injection" broadly enough to cover your attack families
CySecBench and the forbidden-question set are **harmful requests**, not instruction-override attacks. A strict examiner may say that 595 of the 1,793 test "attacks" are not prompt injection. You already define semantic mimicry well; add one sentence in §1.1 or §2.2 placing all four families under one umbrella. **OWASP LLM01:2025 itself treats jailbreaking as a form of prompt injection** (check the exact wording on the OWASP page and cite it). Use a single term, e.g., "adversarial prompts (prompt injection and jailbreak)".

### M4. Remove "the earlier draft" from the final thesis
The body mentions "the earlier draft" 18 times, in §3.4, §3.7, §3.9 (eq. 3.1), §3.11 (ASR and MTTD), §4.3, §4.4, §4.5, §4.7, §4.10 and §4.11, and Appendix D lists earlier figures that were "not produced by any experiment" (100 % recall, 0 % ASR, and others).
Examiners never saw that draft. Keeping these references in a final thesis invites questions about research integrity that the current, honest thesis does not deserve.
**Fix:**
- Move Appendix D into a **separate correction memo to your supervisor**, not the thesis.
- Rewrite each mention neutrally. For example, motivate the fixed (0.4, 0.4, 0.2) fusion as *"a fixed-weight sum-rule baseline (Kittler et al., 1998) with an interaction term"*. Motivate response-level ASR by *"defining ASR as 1 − recall would make it a restatement of recall"*, with no reference to a draft. Motivate the entropy analysis by the base paper's own claims (§8.2 of Alshammari & Alsaleh: 4.8 → 2.1 bits).

### M5. Chapter Two is short for a KNUST MPhil
At about 7 pages, Chapter 2 is lean. Examiners usually expect a fuller conceptual, theoretical and empirical review. Gaps that are directly relevant to your own design choices:
- **Multi-turn attacks** (Crescendo, Russinovich et al., 2025; many-shot jailbreaking, Anil et al., 2024). You model sessions, so you should review session-level attacks.
- **Automated attacks** in more depth (PAIR, TAP, GCG). You use their JailbreakBench artefacts.
- **SOC alert fatigue**, empirical (Alahmadi et al., 2022, *"99% false positives"*, USENIX Security). This directly supports your prevalence argument.
- **MITRE ATLAS** as the SOC taxonomy for LLM attacks.
- **The Ghanaian context**: Data Protection Act 2012 (Act 843), Cybersecurity Act 2020 (Act 1038), the Bank of Ghana Cyber and Information Security Directive (2018). Ghana currently appears only in §1.6.
- An **empirical review table** of prior detection studies (dataset, method, metrics, limitation) and a short **conceptual framework** section.

My earlier draft `thesis/Chapter_2_Literature_Review.md` already contains most of this material (§2.3.2 multi-turn and low-resource attacks, §2.5.3 alert fatigue, §2.5.4 ATLAS, §2.9 Ghana). It can be merged into your chapter.

### M6. Explain the threshold transfer gap
Stream B, fixed fusion and learned fusion were thresholded for **FPR 0.05** on out-of-fold training benign data, yet test FPR is **0.026–0.040**. Explain why: out-of-fold scores are noisier than full-model scores, or training benign data is harder than test benign data. Otherwise examiners will ask whether the operating points are comparable.

### M7. The hard-benign set is soft for semantic mimicry
"Security-themed benign" means Alpaca items that happen to contain security vocabulary. These are not **topic-matched** to CySecBench, i.e., legitimate defensive security questions ("How do I configure a WAF?", "Explain how SQL injection works"). Stream B's FPR on genuine security-education traffic, the traffic a bank's security chatbot would actually see, may therefore be underestimated.
**Fix (optional, strengthens RQ2):** add a few hundred legitimate security questions from a public cybersecurity Q&A/knowledge benchmark (e.g., CyberMetric or SecQA; check licences) as a third benign type in Table 4.6.

### M8. State the assumptions behind prevalence adjustment
Eq. 2.2 assumes recall and FPR stay constant as prevalence changes, and that the attack-family mix stays the same. Add one sentence. If you can, give a bootstrap CI for precision at 1 % prevalence (propagate the recall and FPR bootstrap draws through eq. 2.2).

---

## 4. Minor issues and presentation (quick fixes)

| # | Location | Issue | Fix |
|---|---|---|---|
| m1 | All equations (2.1, 2.2, 3.1, 3.2, 3.3, latency model in §3.4) | **Rendered as raw LaTeX code** in grey boxes, not as equations | Use Word's equation editor (Alt + =) or export via pandoc/LaTeX |
| m2 | Page 1 | Tool artefacts: "Oct 27, 2026 · @John", "FRONT MATTER", running header with full title on every page | Proper KNUST title page (title, name, previous degree, degree sought, department, month/year); remove artefacts |
| m3 | Table of contents, lists of tables and figures | Written as paragraph lists without page numbers | Generate automatically in Word |
| m4 | Figure 3.1 | ASCII diagram wraps badly across pages 18–19 | Redraw in draw.io/Visio as an image |
| m5 | Abstract | About 470 words | Check the SGS word limit (often 250–300) and trim |
| m6 | §4.7 | "In a separate simulation run, Stream A's recall fell from 0.639..." while the main result is 0.566 | Say which configuration gives 0.639 (risk feature disabled? different seed?) |
| m7 | Table 4.1 | AUC for Scenario B "not computed" | Compute it (rules give a discrete score) or explain why |
| m8 | §3.12 | Bootstrap CIs only for recall and F1 | Add CIs for FPR (most important for SOC use) |
| m9 | Table 4.8 | Session MTTD is dominated by the fixed 2 s spacing (you note this) | Present **session coverage** as the main metric and MTTD as secondary, or move MTTD to an appendix |
| m10 | List of abbreviations | DSN, JBC, KQL, PAIR used but not all listed; "LOFO" used only once | Complete the list |
| m11 | §1.5 | "English-language prompts only" | Cross-reference future-work item 6 (Ghanaian languages) |
| m12 | Reference list | Generally accurate. Check the pages for Schulhoff et al. if added; Robey et al. 2023 (arXiv) also has a 2025 TMLR version | Cite the peer-reviewed version where one exists |

---

## 5. Questions to prepare for the viva

1. *"Your telemetry is simulated. Why should we believe Stream A's numbers?"* Answer: prompt features use real text and response features use real generations; comparisons between detectors are the main result; compliance sensitivity is in Table 4.11. Then address C1 and C2.
2. *"Is your n-gram model really semantic?"* (M1)
3. *"How were sessions formed, and can the rules see the future?"* (C1)
4. *"Stream A detects 100 % of unseen direct injection. Isn't that just your keyword regex?"* (C3)
5. *"Did you deploy Elastic SIEM?"* (M2) Answer honestly: designed and specified, rules simulated; deployment is future work.
6. *"Why did you choose ν = 0.05 and γ = 0.1?"* Answer: replication fidelity. Consider a small sensitivity grid to strengthen this.
7. *"What is the practical recommendation for a Ghanaian bank?"* §5.4 tiered policy plus prevalence-based thresholds. Practise a two-minute answer.

---

## 6. Suggested priority order

1. **M4** (remove earlier-draft references) and **m1–m4** (formatting): no new experiments needed.
2. **C1, C3, C4**: small reruns using code you already have.
3. **C2, M2, M3, M6, M8**: wording, plus one descriptive table.
4. **M5**: expand Chapter 2 (merge from the existing draft).
5. **M1** (transformer Stream B) and **M7** (topic-matched benign): the largest gains, but require compute or new data.
