#pragma once

#include "hellinger.h"
#include "simulator.h"
#include <algorithm>
#include <array>
#include <fstream>
#include <vector>

// OSSERVARE BATTERIA

static constexpr int BATTERY_MAX = 10;

struct BATTERY_STATE : public STATE {
    int pos;
    int battery_level;
};

class BATTERY_METAINFO : public BELIEF_META_INFO
{
    std::array<int, BATTERY_MAX + 1> distr;
    int total = 0;

public:
    BATTERY_METAINFO() : distr() {
        for (auto &i : distr) i = 0;
    }

    virtual void update(STATE *s) {
        const BATTERY_STATE& state = safe_cast<const BATTERY_STATE&>(*s);
        total++;
        distr[state.battery_level] += 1;
    }

    virtual void clear() {
        total = 0;
        std::fill(distr.begin(), distr.end(), 0);

    }

    int get_total() const { return total; }

    double get_battery_prob(int level) const { 
        return static_cast<double>(distr[level]) / total;
    }

    virtual BELIEF_META_INFO *clone() const {
        return new BATTERY_METAINFO(*this);
    }
};

enum {
    ACTION_CHECK    = 0,
    ACTION_ADVANCE  = 1,
    ACTION_RECHARGE = 2
};

enum {
    //OBS_LOW,   // less than half battery
    //OBS_HALF,  // at least half battery
    //OBS_FULL,  // full battery
    OBS_NONE = BATTERY_MAX + 1
};

class BATTERY : public SIMULATOR
{
public:
    BATTERY(int length, std::vector<int> stops);

    virtual STATE* Copy(const STATE& state) const;
    virtual void Validate(const STATE& state) const;
    virtual STATE* CreateStartState() const;
    virtual void FreeState(STATE* state) const;
    virtual bool Step(STATE& state, int action, 
            observation_t& observation, double& reward) const;

    void GenerateLegal(const STATE& state, const HISTORY& history,
            std::vector<int>& legal, const STATUS& status) const;
    void GeneratePreferred(const STATE& state, const HISTORY& history,
            std::vector<int>& legal, const STATUS& status) const;
    virtual bool LocalMove(STATE& state, const HISTORY& history,
            int stepObservation, const STATUS& status) const;

    virtual void DisplayBeliefs(const BELIEF_STATE& beliefState,
            std::ostream& ostr) const;
    virtual void DisplayState(const STATE& state, std::ostream& ostr) const;
    virtual void DisplayObservation(const STATE& state, observation_t observation, std::ostream& ostr) const;
    virtual void DisplayAction(int action, std::ostream& ostr) const;
    void DisplayStateId(const STATE& state, std::ostream& ostr) const;
    virtual void DisplayBeliefIds(const BELIEF_STATE& beliefState,
            std::ostream& ostr) const;
    virtual void DisplayBeliefDistribution(const BELIEF_STATE& beliefState,
            std::ostream& ostr) const;
    virtual void log_problem_info() const;
    virtual void log_beliefs(const BELIEF_STATE& beliefState) const;
    virtual void log_state(const STATE& state) const;
    virtual void log_action(int action) const;
    virtual void log_observation(const STATE& state, observation_t observation) const;
    virtual void log_reward(double reward) const;

    virtual void set_belief_metainfo(VNODE *v, const SIMULATOR &s) const;
    virtual void FreeMetainfo(BELIEF_META_INFO *m) const {
        BATTERY_METAINFO *tm = safe_cast<BATTERY_METAINFO*>(m);
        delete m;
    }

    virtual void pre_shield(const BELIEF_STATE &belief, std::vector<int> &legal_actions) const;

private:
    mutable MEMORY_POOL<BATTERY_STATE> MemoryPool;

    int length;
    std::vector<int> stops;
    int nofuel_penalty, check_penalty, step_penalty, recharge_penalty, wrong_charge_penalty, end_reward;
    double prob_correct_obs;

    mutable std::uniform_real_distribution<> unif_dist;
};

