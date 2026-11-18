# KNUST Thesis Guide: Compliance Check and Ready-to-Use Additions

**Thesis checked:** *Dual-Stream Prompt Injection Detection for LLM Gateways: Fusing Telemetry Anomaly Detection with Semantic Intent Classification under Realistic Prevalence* (58-page PDF, 27 Oct 2026).
**Against:** *Guide for Preparation and Evaluation of Higher Degree Research Thesis*, KNUST School of Graduate Studies, June 2016 (Option 1: Thesis as a Monograph), and the MPhil marking scheme in its Appendix 4.4.

Part 1 shows where marks are at risk. Part 2 is a requirement-by-requirement checklist. Part 3 gives text you can paste in, written to match your existing results.

---

## Part 1: Where the marks are (MPhil scheme, Appendix 4.4)

| Criterion | Marks | Current state | Risk |
|--------|--|------------|----|
| 1. Problem statement and justification | 10 | Clear problem, RQs and objectives. **No hypotheses/propositions**; the local (Ghana) justification is thin (1b asks for "local and/or international perspectives") | Low–Medium |
| 2. Critical literature review and **theoretical/conceptual framework** | **25** | Good critical analysis, but short (about 7 pages) and **no theoretical or conceptual framework**. The guide calls the framework "an essential part of the literature review" and it is worth 5 marks (2e) | **High (largest block of marks)** |
| 3. Research design and methodology | **20** | Strong design. Missing a **statement of research philosophy** (the guide says it "must" be stated), **sampling procedure and sample-size justification** (7 marks), and an explicit **link to the conceptual framework** (also a "must") | **High** |
| 4. Analysis and presentation of results | 12.5 | Strong (CIs, McNemar, seeds). Several figures duplicate tables | Low |
| 5. Main findings and discussion | 12.5 | Good. Discussion should start from the theoretical framework and compare more with the literature | Medium |
| 6. Conclusions and recommendations | 10 | Good. Add **policy recommendations** (6c) | Low |
| 7. Presentation | 10 | Several formatting rules not met (font, spacing, pagination, abstract length, declaration wording, equations) | Medium |

**Priority:** the **conceptual/theoretical framework** (Criterion 2), then **philosophy and sampling** (Criterion 3), then formatting (Criterion 7). Part 3 gives draft text for all three.

---

## Part 2: Requirement-by-requirement checklist

✅ = meets guide · ⚠️ = partly · ❌ = does not meet

### A. Preliminary section

| # | Guide requirement | Your thesis | Status | Fix |
|--|---------|-------|---|-------|
| 1 | **Title page** (App. 1): title; "By"; full name (first, middle, surname, no prefix); **qualifications held in brackets** (not the one sought); "A thesis submitted to the Department of …, KNUST, Kumasi in partial fulfilment of the requirements for the award degree of MASTER OF PHILOSOPHY IN CYBERSECURITY"; **month and year** | Title page is a paragraph under a "FRONT MATTER" heading with "Oct 27, 2026 · @John" tags; no qualifications held; year but no month | ❌ | Use the title page in Part 3.1 |
| 2 | Intellectual Property Rights statement, *if applicable* | None | ✅ (likely N/A) | Optional: one line noting public datasets used under their licences |
| 3 | **Declaration**: exact wording given in the guide, plus signature block "Name of Student / Name and ID / Signature / Date; Certified by: Supervisor; Certified by: Head of Department" (App. 2) | Different wording; separate "Supervisor's Declaration" paragraph | ❌ | Use the exact text in Part 3.2 |
| 3a | Position of declaration: the guide's text says "on the first page after the table of contents", but its contents list puts it before the abstract | Before abstract | ⚠️ | **Ask your department** which order it enforces; follow recent approved CS theses |
| 4 | **Abstract: one paragraph, ≤ 350 words (Master)**, opening with an orienting sentence and covering objective, importance, method, findings, conclusion, implications | **Three paragraphs, about 470 words** | ❌ | Use the 349-word one-paragraph abstract in Part 3.3 |
| 5 | **Table of Contents with page numbers**; headings exactly as in the text, including the word "Chapter" | Paragraph list, no page numbers | ❌ | Generate automatically in Word (References → Table of Contents) |
| 6 | **List of Tables** on a separate page: columns *Table No. · Title · Page* | No page numbers | ❌ | Word: References → Insert Table of Figures → Caption label "Table" |
| 7 | **List of Figures** on a separate page: *Figure No. · Caption · Page* | No page numbers | ❌ | As above with label "Figure" |
| 8 | List of Abbreviations, **alphabetical** | Alphabetical ✅; missing DSN, JBC, KQL, LOFO (defined once), SVDD | ⚠️ | Complete the list |
| 9.1 | Acknowledgements on a **separate page**; name substantial help (data, statistics, **editing**, graphics, word processing) and note if any was **paid** | Present | ⚠️ | See note on editorial and AI assistance below |
| 9.2 | Ethical approval page *only if humans/animals are involved* | Not needed; §3.14 states no human participants | ✅ | None |
| 9.3 | **Professional Editorial Assistance**: name and services on a separate page; editing limited to formatting, grammar and style, and **must not alter or improve substantive content** | Not present | ⚠️ | **See note below** |

> **Note on editorial and AI assistance (important).** The 2016 guide predates generative AI, but its rule on editorial help is clear: outside help must be disclosed and must not change the substantive content. Check the **current SGS or departmental policy on AI-assisted writing** with Prof. Twum *before* submission, and disclose any AI tools used (including this review and any drafted text you adopt) in the way the policy requires. The guide also warns that copying a whole paragraph is plagiarism *even with a citation*, and theses go through a plagiarism check. **Rewrite any drafted text you take from me in your own words** rather than pasting it in unchanged.

### B. Main text (Option 1: Monograph)

| # | Guide requirement | Your thesis | Status | Fix |
|--|---------|-------|---|-------|
| 10 | Ch. 1 should state the problem, objectives and **"a well-defined hypothesis, which should be clearly stated"**, and end with the specific objectives | RQs and objectives present; **no hypotheses** | ❌ | Add the propositions in Part 3.4 |
| 11 | Ch. 1 should describe the **conceptual framework** as the "theme" tying the work together, plus **theoretical assumptions and their limitations**, expected outcome and **beneficiaries** | Not present (significance section names some beneficiaries) | ⚠️ | Add a short paragraph pointing to the framework (Part 3.5) and list assumptions (simulated telemetry, neutral injection goals, English only) |
| 12 | Ch. 1 may include justification, scope, **summary of methodology**, **limitations**, organisation | Scope ✅, organisation ✅; no methodology summary; limitations only in Ch. 5 | ⚠️ | Add a 1-paragraph §1.x Summary of Methodology and a short Limitations subsection |
| 13 | Ch. 1 justification "in local and/or international perspectives" (marking 1b) | Ghana appears briefly in §1.1 and §1.6 | ⚠️ | Add Ghana context: Act 843, Act 1038, Bank of Ghana Cyber & Information Security Directive (2018), CSA. Material is in my earlier Ch. 2 draft §2.9 |
| 14 | Ch. 2 must "summarise, evaluate and compare", use "most relevant and latest" literature, and **include the theoretical/conceptual framework as an essential part** | Critical and current, but short; **no framework** | ❌ | Add §2.10 Theoretical Framework and §2.11 Conceptual Framework (Part 3.5); expand with multi-turn attacks, alert fatigue, ATLAS and Ghana context |
| 15 | Ch. 3 methodology **must state the research philosophy** (positivism, pragmatism, etc.) | Not stated | ❌ | Add Part 3.6 |
| 16 | Ch. 3 **sampling procedure: population, sampling frame, technique, sample size with justification** (7 marks) | Corpus well described but not framed as sampling; no size justification | ❌ | Add Part 3.7 |
| 17 | Ch. 3 methodology **must draw links with the conceptual framework** | Not present | ❌ | One paragraph mapping constructs to measured variables (end of Part 3.5) |
| 18 | Ch. 4 results "build up to the objectives"; sub-chapters may be headed by objective | Organised by experiment E1–E9 with an RQ map (Table 3.4) | ✅ | Optional: add the objective number to each §4.x heading |
| 19 | **"Do not present the same data in a graph/figure as well as in a table"**; use error bars where possible | Error bars ✅. But **Figs 4.1, 4.2, 4.3, 4.5, 4.6, 4.7, 4.8, 4.9 repeat Tables 4.1, 4.3, 4.6, 4.9, 4.12, 4.13, 4.7, 4.10** | ❌ | Keep **one** of each pair in the chapter. Figures suit trends (Fig 4.4 ROC, Fig 4.5 prevalence curve); tables suit exact values. Move the duplicate to an appendix or drop it |
| 20 | Negative results should be reported and justified | Done very well (fixed fusion, LOFO, obfuscation) | ✅ | None |
| 21 | Discussion should **begin with findings in relation to the theoretical framework** and compare with published work | §4.11 compares with the base paper; little framework or wider literature | ⚠️ | Open §4.11 with the signal-detection/base-rate framing (Part 3.5) and compare with PromptShield, Wei et al., Arp et al., Sommer & Paxson |
| 22 | Conclusions: answer the RQs, contributions, limitations, recommendations, future work; **policy recommendations / industrial application** (marking 6c) | All present except policy | ⚠️ | Add §5.4.x *Recommendations for policy*: e.g., CSA/Bank of Ghana guidance requiring LLM gateway logging into SOC/SIEM, prevalence-adjusted reporting in vendor evaluations, and privacy-safe telemetry under Act 843 |
| 23 | Five-chapter structure acceptable? The guide's Option 1 lists Discussion and Conclusions as Ch. 5 and Ch. 6, but allows departmental variants | Ch. 4 Results and Discussion; Ch. 5 Summary, Conclusions and Recommendations | ✅ | Confirm with department; this format is common at KNUST |

### C. References

| # | Guide requirement | Your thesis | Status | Fix |
|--|-------|---------|---|-------|
| 24 | **Harvard style**, alphabetical, consistent; "and" between two authors; *et al.* in text for 3+ authors | Harvard-style, alphabetical, consistent | ✅ | None |
| 25 | Online sources: "Available: URL [Accessed date]" | OWASP, GitHub datasets (Alpaca, CySecBench, BIPIA, HarmBench, JailbreakBench, jailbreak_llms) lack URL or accessed date in the list | ⚠️ | Add *Available:* and *[Accessed dd/mm/yyyy]* to every web or GitHub reference |
| 26 | "Those not read should not be quoted" | Viva risk only | ✅ | Be ready to discuss every cited paper |

### D. Mechanics of presentation (Section G)

| # | Guide requirement | Your thesis (PDF) | Status |
|--|---------|--------|----|
| 27 | **Times New Roman 12 pt** throughout; footnotes smaller | Different serif/sans fonts | ❌ |
| 28 | **1.5 line spacing**; single spacing for abstract, quotations, footnotes, references, captions | Not 1.5 | ❌ |
| 29 | A4; margins **2.5 cm, gutter 4 cm**; double-sided | Unknown/not set | ❌ |
| 30 | **Text fully justified** | Left-aligned (ragged right) | ❌ |
| 31 | Page numbers **centred at the bottom**; title page unnumbered (counts as i); prelims **lower-case Roman** from ii; main text **Arabic from 1** | "Page X of 58" bottom right, continuous | ❌ |
| 32 | **Each chapter starts on a new page** | Chapters run on (e.g., Ch. 2 begins mid-page 11) | ❌ |
| 33 | Table captions **above**; figure captions **below**; numbered by chapter | ✅ | ✅ |
| 34 | Figures **numbered in order of appearance** (implied by chapter numbering) | Order in text: 4.1, 4.2, **4.4, 4.3, 4.8, 4.5, 4.9, 4.6, 4.7** | ❌ Renumber |
| 35 | Max **4 heading levels**; levels typographically distinct | 3 levels ✅ | ✅ |
| 36 | **Every paragraph ≥ 3 sentences**, one main idea, topic sentence | Several 1–2-sentence paragraphs, e.g. "Figure 3.1 shows the architecture evaluated.", "Four observations follow.", "Three results stand out.", "Table 2.1 summarises representative defences." | ❌ Merge into neighbouring paragraphs |
| 37 | Word limit: MPhil ≤ 60,000 words | About 17,000 words | ✅ (room to expand Ch. 2) |
| 38 | Equations (not in guide, but "clarity" counts under Presentation) | **Raw LaTeX code** in grey boxes | ❌ Retype with Word Equation Editor |
| 39 | Running header (not in guide) | Full title at the top of every page | ⚠️ Remove |

### E. Submission and graduation

| # | Requirement | Action |
|--|--------|----------|
| 40 | Assessment copies: **3 comb-bound copies** (Master) | Print after all fixes |
| 41 | Final copies after approval: bound in **deep blue** (Master), front cover lettered with title, author, month and year; spine with degree, year and name; **PDF to SGS** | After the viva |
| 42 | Section D: candidates are "expected to show evidence" of **publication or submission for publication** during examination (see Handbook §12) | **Start a paper now**, for example the replication and prevalence findings plus the fusion results. Agree authorship with Prof. Twum early, as the guide requires |
| 43 | Oral exam (App. 4.5): PowerPoint 15, understanding 45, questions 40 | Prepare slides on problem, framework, methods, findings and contributions; practise the viva questions in the examiner review |

---

## Part 3: Ready-to-use additions

> These drafts use only numbers already in your thesis. If you rerun experiments after the examiner-review fixes (C1–C4), update the numbers. Adapt the wording to your own voice (see the note in Part 2.A).

### 3.1 Title page (App. 1 format)

> DUAL-STREAM PROMPT INJECTION DETECTION FOR LLM GATEWAYS: FUSING TELEMETRY ANOMALY DETECTION WITH SEMANTIC INTENT CLASSIFICATION UNDER REALISTIC PREVALENCE
>
> By
>
> John [Middle name, if any] Agyin
>
> ([Qualification held, e.g., BSc. Computer Science])
>
> A thesis submitted to the Department of Computer Science, Kwame Nkrumah University of Science and Technology, Kumasi in partial fulfilment of the requirements for the award degree of
>
> MASTER OF PHILOSOPHY IN CYBERSECURITY
>
> [Month], [Year]

### 3.2 Declaration (exact wording required by the guide)

> I hereby declare that this submission is my own work and that, to the best of my knowledge and belief, it contains no material previously published or written by another person nor material which to a substantial extent has been accepted for the award of any other degree or diploma at Kwame Nkrumah University of Science and Technology, Kumasi or any other educational institution, except where due acknowledgment is made in the thesis.
>
> John Agyin (PG________) ………………… …………………
> Name of Student and ID   Signature   Date
>
> Certified by:
> Prof. F. Twum ………………… …………………
> Name of Supervisor   Signature   Date
>
> Certified by:
> ……………………… ………………… …………………
> Name of Head of Department   Signature   Date

### 3.3 Abstract: one paragraph, 349 words

> Prompt injection, ranked first in the OWASP Top 10 for Large Language Model (LLM) Applications, allows untrusted text to override the instructions of LLM-based systems because instructions and data share one context window. A recent framework brought LLM gateway telemetry into Security Operations Centres (SOCs) through Security Information and Event Management (SIEM) rules and a One-Class Support Vector Machine (OCSVM), but it does not read prompt content and was evaluated on a test set that was 81.8% attacks. This study aimed to determine whether, and how, a semantic intent stream should be fused with telemetry anomaly detection to detect prompt injection at an SOC-integrated LLM gateway. A leakage-controlled benchmark of 13,181 prompts was assembled from 35 public sources, with training and test pools separated by source, attack strategy and jailbreak community, and gateway telemetry was generated by a trace-driven simulator using real prompts and real model responses. The base framework was replicated, and Stream A (the OCSVM) was combined with Stream B (a word and character n-gram intent classifier) under fixed, learned and either-stream fusion. All detectors were evaluated on 3,835 held-out prompts using bootstrap confidence intervals, McNemar tests, response-level Attack Success Rate (ASR) and prevalence-adjusted precision. The replication held in direction (recall 0.178, 0.720 and 0.781 across its three scenarios), but its false positive rate (FPR) doubled to 0.220 and its precision fell to 0.035 at 1% attack prevalence. Stream B reached recall 0.828 at FPR 0.026. Fixed-weight fusion was significantly worse than Stream B alone (p < 0.001), whereas learned stacking was significantly better (recall 0.845, FPR 0.027, F1 0.901), reduced ASR from 44.1% to 7.8% and added about 3.4 ms of CPU latency per request. Stream B failed on attack families absent from training (recall 0.00 to 0.16), where only an either-stream policy retained Stream A's detection, and obfuscation defeated it until a canonicalisation step restored recall to between 0.71 and 0.81. The study concludes that telemetry and semantic detection are complementary only under an appropriate fusion and alert policy, and recommends a tiered SOC alerting design with thresholds set for each deployment's actual attack prevalence.
>
> **Keywords:** prompt injection; large language models; anomaly detection; one-class SVM; SIEM; decision fusion; base-rate fallacy; adversarial robustness

*(Keep the keywords on their own line below the paragraph. If any result changes after reruns, recount the words: the limit is 350.)*

### 3.4 Research propositions (for §1.4, after the research questions)

The guide asks for "a well-defined hypothesis". Your RQs were set and answered before hypotheses were written, so use the guide's alternative wording, **propositions**, to avoid the appearance of hypothesising after the results are known. Each proposition maps to an RQ and to a test you already ran.

> **1.5 Research Propositions**
> In line with the research questions, the study tests the following propositions:
> - **P1 (RQ1).** Telemetry-only anomaly detection detects attacks that change model behaviour, such as direct injection and refusal-provoking jailbreaks, at substantially higher rates than attacks that do not, such as semantic mimicry and indirect injection. *Tested by per-category recall with bootstrap confidence intervals.*
> - **P2 (RQ2).** A semantic intent classifier achieves higher recall than telemetry-only detection at a lower false positive rate, including on hard benign prompts. *Tested by McNemar's test and per-type FPR.*
> - **P3 (RQ3).** Fusing the two streams improves on the better single stream only when the fusion weights are learned from data; a fixed equal-weight fusion does not. *Tested by McNemar's test between each fusion rule and Stream B.*
> - **P4 (RQ4).** The precision of all detectors falls sharply as attack prevalence falls from attack-heavy to realistic levels, so that detectors with similar precision at 81.8% prevalence differ greatly at 1%. *Tested by prevalence-adjusted precision (equation 2.2).*
> - **P5 (RQ5).** The semantic stream's recall degrades on attack families absent from training and under obfuscation, whereas the telemetry stream degrades less, and input canonicalisation restores semantic recall without materially increasing false positives. *Tested by leave-one-family-out and obfuscation experiments.*

In Chapter 5, add a sentence per proposition: *supported*, *partly supported* or *not supported*. From your current results: P1 supported; P2 supported; P3 supported; P4 supported; P5 supported, except that canonicalisation does not handle character spacing (partly supported).

### 3.5 Theoretical and conceptual framework (new §2.10 and §2.11 in Chapter 2)

> **2.10 Theoretical Framework**
>
> The study draws on two bodies of theory. The first is **signal detection theory** and its Bayesian extension to intrusion detection. Signal detection theory treats any detector as a decision rule that separates "signal" (attacks) from "noise" (benign traffic) on the basis of a score, with a threshold that trades the true positive rate against the false positive rate (Green and Swets, 1966). Axelsson (2000) applied Bayes' theorem to intrusion detection and showed that the proportion of alarms that are real depends not only on these two rates but also on the base rate of attacks (equation 2.2). From this theory the study takes three assumptions: detectors should be compared on their full score distributions (ROC analysis), operating thresholds must be fixed before testing, and operational value must be judged at the prevalence a deployment will face rather than at the prevalence of a test set.
>
> The second is **multiple-classifier (decision fusion) theory**. Kittler et al. (1998) showed that fixed combination rules such as the weighted sum work well when the combined classifiers are of similar quality and make independent errors. Wolpert (1992) showed that a second-level learner trained on out-of-fold outputs can learn how much to trust each classifier. Together these theories predict that combining two detectors helps only when their errors are complementary and their weights reflect their reliability, and that a weak member given equal weight can degrade a strong one. The theory of **defence in depth**, standard in security practice, adds the expectation that independent layers protect against the failure of any single layer.
>
> **2.11 Conceptual Framework**
>
> Synthesising these theories with the literature reviewed above, the study adopts the conceptual framework in Figure 2.1. A request reaching the LLM gateway produces two kinds of evidence: **behavioural telemetry** (token counts, response entropy, refusal, latency, keyword and session signals) and **prompt text**. These feed two detection streams. Stream A models normal behaviour without attack labels, and Stream B classifies intent from text. A **fusion and alert policy** (fixed, learned or either-stream) turns the two scores into decisions that are forwarded to the SIEM and the SOC. The framework identifies four **moderating conditions** that the literature suggests will change how well each stream works: (i) **attack prevalence**, from signal detection theory; (ii) **novelty of the attack family**, from the generalisation pitfalls described by Arp et al. (2022); (iii) **obfuscation**, from mismatched generalisation (Wei et al., 2023); and (iv) the **target model's compliance behaviour**, since telemetry signals such as refusal exist only when the model resists. The **outcome constructs** are detection effectiveness (recall, FPR, AUC), operational value (prevalence-adjusted precision, alert burden), harm prevented (response-level ASR) and cost (latency).
>
> ```
>   INPUT EVIDENCE            DETECTION STREAMS          DECISION            OUTCOMES
>  ┌──────────────────┐     ┌──────────────────────┐
>  │ Gateway telemetry│────►│ Stream A: OCSVM       │──┐
>  │ (behaviour)      │     │ (benign-only model)   │  │  ┌──────────────┐   Recall, FPR, AUC
>  └──────────────────┘     └──────────────────────┘  ├─►│ Fusion &     │──► Precision at π
>  ┌──────────────────┐     ┌──────────────────────┐  │  │ alert policy │──► Response-level ASR
>  │ Prompt text      │────►│ Stream B: intent      │──┘  │ (fixed/learned│──► Latency / alert load
>  │ (+ canonicaliser)│     │ classifier (supervised)│    │ /either)      │        │
>  └──────────────────┘     └──────────────────────┘     └──────────────┘        ▼
>                                                                         SIEM rules → SOC/SOAR
>        MODERATORS: attack prevalence (π) · attack-family novelty · obfuscation · model compliance
> ```
> **Figure 2.1: Conceptual framework of the study** *(redraw in draw.io or Visio)*
>
> Each part of the framework corresponds to part of the methodology: the two input types to the telemetry simulator and corpus (§3.2–3.4), the streams to §3.5–3.8, the decision layer to §3.9–3.10, the moderators to Experiments E5–E8, and the outcomes to the metrics in §3.11.

*(Add Green, D. M. and Swets, J. A. (1966). Signal Detection Theory and Psychophysics. New York: Wiley. to the references. Kittler, Wolpert, Axelsson, Arp and Wei are already in your list.)*

**Also add to Chapter 1:** a short paragraph introducing the framework as the study's "theme", e.g., *"The study is framed by signal detection theory and decision-fusion theory (Section 2.10), from which a conceptual framework (Figure 2.1) is developed linking two evidence streams, a fusion policy and four moderating conditions to detection, operational and harm outcomes."*

### 3.6 Research philosophy (new opening of §3.1)

> The study adopts a **positivist** research philosophy. Positivism holds that knowledge is gained through objective observation and measurement, and that claims should be tested empirically against data that other researchers can reproduce. This fits the research problem, which concerns measurable properties of detectors (recall, false positive rate, precision under prevalence, attack success rate) that can be compared with statistical tests. Consistent with this philosophy, the study uses a quantitative, experimental design: propositions derived from the theoretical framework are tested on a fixed, held-out test set with thresholds set in advance, confidence intervals and paired significance tests. The artefact-building element of the study (designing and implementing the dual-stream detector) follows the build-and-evaluate cycle of design science, with evaluation carried out under the positivist criteria above.

### 3.7 Sampling procedure and sample-size justification (new §3.2.1)

> **Population and sampling frame.** The target population is the set of prompts that reach an enterprise LLM gateway: benign requests (general instructions, security-themed questions, role-play and retrieval-augmented tasks) and adversarial requests (direct injection, indirect injection, semantic mimicry and jailbreak framing). Since no production traffic was available, the sampling frame consists of 35 public sources that represent these categories (Table 3.1).
>
> **Sampling technique.** Sources were selected **purposively**, to cover each attack family and benign type identified in the literature (Section 2.2). Within each source, prompts were sampled at random with a fixed seed and **stratified** by class and family. Partitioning into training and test sets used **group-disjoint sampling** by source, attack strategy, jailbreak community and document context (Table 3.2), so that no near-duplicate group appears on both sides.
>
> **Sample size.** The test partition contains 1,793 attacks and 2,042 benign prompts. For a proportion p estimated from n observations, the 95% confidence half-width is about 1.96·√(p(1 − p)/n). With n = 1,793 the half-width for recall is at most ±2.3 percentage points (at p = 0.5) and about ±1.7 points at the observed recall of 0.845, which matches the bootstrap interval [0.828, 0.861]. With n = 2,042 benign prompts the half-width for an FPR of 0.027 is about ±0.7 points, enough to separate detectors whose FPRs differ by a few points. The smallest analysed group, direct injection (n = 200), has a worst-case half-width of about ±6.9 points, so per-category results for small groups are interpreted with caution (Section 4.11). The training partition (9,346 prompts, of which 4,200 benign) exceeds the base paper's 1,200 benign training interactions by a factor of 3.5.

---

## Part 4: Suggested order of work

1. **Formatting pass** in Word (items 27–39). Use the template `KNUST_Thesis_Template.docx`, which already has Times New Roman 12, 1.5 spacing, justified text, the required margins and gutter, and centred page numbers.
2. Replace the **title page, declaration and abstract** (Part 3.1–3.3).
3. Add the **theoretical and conceptual framework** (Part 3.5) and expand Chapter 2.
4. Add **philosophy, sampling and the framework link** to Chapter 3 (Part 3.6–3.7).
5. Add **propositions** to Chapter 1 and *supported / not supported* statements to Chapter 5 (Part 3.4).
6. Remove duplicate figures/tables, renumber figures, merge short paragraphs, add policy recommendations.
7. Address the examiner-review items C1–C4 and M1–M8.
8. Confirm the AI/editorial disclosure policy, run the plagiarism check, and start the publication.
