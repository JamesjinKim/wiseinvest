// WiseInvest - Survey JavaScript

document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('surveyForm');
    const questionCards = document.querySelectorAll('.question-card');
    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');
    const submitBtn = document.getElementById('submitBtn');
    const progressBar = document.getElementById('progressBar');
    const progressText = document.getElementById('progressText');
    const progressPercent = document.getElementById('progressPercent');
    const currentQuestionDisplay = document.getElementById('currentQuestion');
    
    let currentQuestion = 1;
    const totalQuestions = 10;
    const answers = {};
    
    // Initialize first question
    showQuestion(1);
    
    // Answer selection handler
    const answerOptions = document.querySelectorAll('.answer-option input[type="radio"]');
    answerOptions.forEach(option => {
        option.addEventListener('change', function() {
            const questionNum = this.name.replace('q', '');
            answers[questionNum] = this.value;
            updateProgress();
            enableNextButton();
        });
    });
    
    // Previous button
    prevBtn.addEventListener('click', function() {
        if (currentQuestion > 1) {
            currentQuestion--;
            showQuestion(currentQuestion);
            updateNavigation();
        }
    });
    
    // Next button
    nextBtn.addEventListener('click', function() {
        if (currentQuestion < totalQuestions) {
            currentQuestion++;
            showQuestion(currentQuestion);
            updateNavigation();
        }
    });
    
    // Submit button
    submitBtn.addEventListener('click', function(e) {
        e.preventDefault();
        submitSurvey();
    });
    
    // Show specific question
    function showQuestion(questionNum) {
        questionCards.forEach(card => {
            card.classList.remove('active');
        });
        
        const targetCard = document.querySelector(`[data-question="${questionNum}"]`);
        if (targetCard) {
            targetCard.classList.add('active');
            
            // Scroll to top of the card
            window.scrollTo({
                top: targetCard.offsetTop - 100,
                behavior: 'smooth'
            });
        }
        
        currentQuestionDisplay.textContent = questionNum;
        
        // Check if current question is answered
        if (answers[questionNum]) {
            enableNextButton();
        } else {
            disableNextButton();
        }
    }
    
    // Update progress bar
    function updateProgress() {
        const answeredCount = Object.keys(answers).length;
        const progress = (answeredCount / totalQuestions) * 100;
        
        progressBar.style.width = `${progress}%`;
        progressText.textContent = `${answeredCount}/${totalQuestions}`;
        progressPercent.textContent = Math.round(progress);
    }
    
    // Update navigation buttons
    function updateNavigation() {
        // Previous button
        if (currentQuestion === 1) {
            prevBtn.disabled = true;
            prevBtn.classList.add('opacity-50', 'cursor-not-allowed');
        } else {
            prevBtn.disabled = false;
            prevBtn.classList.remove('opacity-50', 'cursor-not-allowed');
        }
        
        // Next/Submit buttons
        if (currentQuestion === totalQuestions) {
            nextBtn.classList.add('hidden');
            submitBtn.classList.remove('hidden');
            
            if (Object.keys(answers).length === totalQuestions) {
                submitBtn.disabled = false;
            } else {
                submitBtn.disabled = true;
            }
        } else {
            nextBtn.classList.remove('hidden');
            submitBtn.classList.add('hidden');
        }
    }
    
    // Enable next button
    function enableNextButton() {
        nextBtn.disabled = false;
        nextBtn.classList.remove('opacity-50', 'cursor-not-allowed');
        
        if (currentQuestion === totalQuestions && Object.keys(answers).length === totalQuestions) {
            submitBtn.disabled = false;
            submitBtn.classList.remove('opacity-50', 'cursor-not-allowed');
        }
    }
    
    // Disable next button
    function disableNextButton() {
        nextBtn.disabled = true;
        nextBtn.classList.add('opacity-50', 'cursor-not-allowed');
    }
    
    // Submit survey
    function submitSurvey() {
        if (Object.keys(answers).length !== totalQuestions) {
            alert('모든 질문에 답변해주세요.');
            return;
        }
        
        // Calculate score
        let totalScore = 0;
        for (let key in answers) {
            totalScore += parseInt(answers[key]);
        }
        
        const averageScore = (totalScore / totalQuestions).toFixed(1);
        
        // Determine risk profile
        let riskProfile = '';
        let riskLevel = '';
        
        if (averageScore <= 2.0) {
            riskProfile = '매우 보수적';
            riskLevel = 'very-conservative';
        } else if (averageScore <= 3.0) {
            riskProfile = '보수적';
            riskLevel = 'conservative';
        } else if (averageScore <= 3.5) {
            riskProfile = '중립적';
            riskLevel = 'neutral';
        } else if (averageScore <= 4.0) {
            riskProfile = '공격적';
            riskLevel = 'aggressive';
        } else {
            riskProfile = '매우 공격적';
            riskLevel = 'very-aggressive';
        }
        
        // Show result modal
        showResultModal({
            totalScore: totalScore,
            averageScore: averageScore,
            riskProfile: riskProfile,
            riskLevel: riskLevel,
            answers: answers
        });
    }
    
    // Show result modal
    function showResultModal(result) {
        const modal = document.createElement('div');
        modal.className = 'modal active';
        modal.innerHTML = `
            <div class="modal-content max-w-2xl">
                <div class="p-8 text-center">
                    <div class="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
                        <i class="fas fa-check text-green-600 text-4xl"></i>
                    </div>
                    <h2 class="text-3xl font-bold text-gray-900 mb-4">설문이 완료되었습니다!</h2>
                    <p class="text-gray-600 mb-8">당신의 투자 성향 분석 결과입니다</p>
                    
                    <div class="bg-gradient-to-br from-blue-50 to-indigo-50 rounded-xl p-8 mb-6">
                        <div class="text-6xl font-bold text-blue-600 mb-2">${result.averageScore}</div>
                        <div class="text-2xl font-semibold text-gray-800 mb-4">${result.riskProfile} 투자자</div>
                        <div class="text-sm text-gray-600">총점: ${result.totalScore} / 50점</div>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
                        <div class="p-4 bg-white rounded-lg shadow">
                            <div class="text-sm text-gray-600 mb-1">리스크 감수도</div>
                            <div class="text-lg font-bold text-gray-900">${getRiskLevel(result.averageScore)}</div>
                        </div>
                        <div class="p-4 bg-white rounded-lg shadow">
                            <div class="text-sm text-gray-600 mb-1">추천 투자 기간</div>
                            <div class="text-lg font-bold text-gray-900">${getInvestmentPeriod(result.averageScore)}</div>
                        </div>
                        <div class="p-4 bg-white rounded-lg shadow">
                            <div class="text-sm text-gray-600 mb-1">추천 포트폴리오</div>
                            <div class="text-lg font-bold text-gray-900">${getPortfolioType(result.averageScore)}</div>
                        </div>
                    </div>
                    
                    <div class="bg-blue-50 p-6 rounded-lg mb-8 text-left">
                        <h3 class="font-semibold text-blue-900 mb-3">
                            <i class="fas fa-lightbulb mr-2"></i>맞춤형 투자 조언
                        </h3>
                        <p class="text-sm text-blue-800">${getAdvice(result.averageScore)}</p>
                    </div>
                    
                    <div class="flex space-x-4">
                        <a href="profile.html" class="btn btn-primary flex-1">
                            <i class="fas fa-chart-bar mr-2"></i>
                            상세 리포트 보기
                        </a>
                        <a href="dashboard.html" class="btn btn-outline flex-1">
                            <i class="fas fa-home mr-2"></i>
                            대시보드로
                        </a>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
    }
    
    // Helper functions
    function getRiskLevel(score) {
        if (score <= 2.0) return '매우 낮음';
        if (score <= 3.0) return '낮음';
        if (score <= 3.5) return '보통';
        if (score <= 4.0) return '높음';
        return '매우 높음';
    }
    
    function getInvestmentPeriod(score) {
        if (score <= 2.0) return '장기 (3년+)';
        if (score <= 3.0) return '중장기 (1-3년)';
        if (score <= 3.5) return '중기 (6개월-1년)';
        if (score <= 4.0) return '단기 (1-6개월)';
        return '초단기 (1개월 이내)';
    }
    
    function getPortfolioType(score) {
        if (score <= 2.0) return '안전자산 중심';
        if (score <= 3.0) return '혼합형';
        if (score <= 3.5) return '균형형';
        if (score <= 4.0) return '성장주 중심';
        return '고위험 고수익';
    }
    
    function getAdvice(score) {
        if (score <= 2.0) {
            return '안정성을 중시하는 당신에게는 대형 우량주와 배당주가 적합합니다. 재무제표를 꼼꼼히 분석하고 장기 투자하세요.';
        } else if (score <= 3.0) {
            return '보수적 성향의 당신은 위험을 최소화하면서도 적정 수익을 추구합니다. 버핏 점수 70점 이상의 종목을 선택하세요.';
        } else if (score <= 3.5) {
            return '균형잡힌 투자자입니다. 안전자산과 성장주를 적절히 배분하고, 시장 상황에 따라 유연하게 대응하세요.';
        } else if (score <= 4.0) {
            return '공격적 투자 성향입니다. 고성장 종목에 투자하되, 과잉 확신 편향을 조심하세요. 손절 원칙을 반드시 지키세요.';
        } else {
            return '매우 공격적인 투자자입니다. 높은 수익을 추구하지만 리스크 관리가 중요합니다. 포트폴리오의 20%는 안전자산으로 유지하세요.';
        }
    }
});
