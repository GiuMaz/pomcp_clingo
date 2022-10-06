#pragma once

#include "simulator.h"
#include <vector>
#include <algorithm>
#include <fstream>
#include <array>
#include "hellinger.h"
#include "utils.h"

static constexpr int CLOSE_BATTERY_MAX = 10;

struct CLOSE_BATTERY_STATE : public STATE {
    int pos;
    int battery_level;
    std::vector<bool> open_stations;
};

class CLOSE_BATTERY_UPDATER;

class CLOSE_BATTERY_METAINFO : public BELIEF_META_INFO
{
    std::array<int, CLOSE_BATTERY_MAX + 1> distr;
    std::vector<int> station_distr;
    int total = 0;

public:
    CLOSE_BATTERY_METAINFO() : distr(), station_distr() {
        for (auto &i : distr) i = 0;
    }

    virtual void update(STATE *s) {
        const CLOSE_BATTERY_STATE& state = safe_cast<const CLOSE_BATTERY_STATE&>(*s);
        if (station_distr.empty())
            station_distr.resize(state.open_stations.size(), 0);

        total++;
        distr[state.battery_level] += 1;
        for (int i = 0; i < state.open_stations.size(); i++)
            if (state.open_stations[i])
                station_distr[i] += 1;
    }

    virtual void clear() {
        total = 0;
        std::fill(distr.begin(), distr.end(), 0);
        station_distr.clear();
    }

    int get_total() const { return total; }

    double get_battery_prob(int level) const { 
        assert(level >= 0 && level <= CLOSE_BATTERY_MAX);
        if (total == 0)
            return 0.0;
        else
            return static_cast<double>(distr[level]) / total;
    }

    double get_station_prob(int station_number) const { 
        if (total == 0)
            return 0.0;
        else
            return static_cast<double>(station_distr[station_number]) / total;
    }

    virtual BELIEF_META_INFO *clone() const {
        return new CLOSE_BATTERY_METAINFO(*this);
    }
};

enum {
    CB_ACTION_CHECK    = 0,
    CB_ACTION_ADVANCE  = 1,
    CB_ACTION_RECHARGE = 2
};

// Observations from 0 to CLOSE_BATTERY_MAX are used to report
// the battery level.
// The other are used to signal an oper or close station (after a move action
// reach a recharge station) or NONE in all the other cases.
enum {
    CLOSE_BATTERY_OBS_OPEN = CLOSE_BATTERY_MAX + 1,
    CLOSE_BATTERY_OBS_CLOSE = CLOSE_BATTERY_MAX + 2,
    CLOSE_BATTERY_OBS_NONE = CLOSE_BATTERY_MAX + 3
};

class CLOSE_BATTERY final: public SIMULATOR
{
public:
    CLOSE_BATTERY(int length, std::vector<int> stops);

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
    virtual void GenerateFromRules(const STATE& state, const BELIEF_STATE &belief,
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
    virtual void log_run_info() const;
    virtual void log_beliefs(const BELIEF_STATE& beliefState) const;
    virtual void log_state(const STATE& state) const;
    virtual void log_action(int action) const;
    virtual void log_observation(const STATE& state, observation_t observation) const;
    virtual void log_reward(double reward) const;

    virtual void set_belief_metainfo(VNODE *v, const SIMULATOR &s) const;
    virtual void FreeMetainfo(BELIEF_META_INFO *m) const {
        CLOSE_BATTERY_METAINFO *tm = safe_cast<CLOSE_BATTERY_METAINFO*>(m);
        delete m;
    }

    virtual void pre_shield(const BELIEF_STATE &belief, std::vector<int> &legal_actions) const;

    void set_updater(CLOSE_BATTERY_UPDATER *u) {
        updater = u;
    }

    void update(const std::vector<int> &stops_update) {
        stops = stops_update;
    }

    virtual void pre_run();

    virtual int get_tree_count(int action) const;

private:
    friend CLOSE_BATTERY_UPDATER;
    mutable MEMORY_POOL<CLOSE_BATTERY_STATE> MemoryPool;

    int length;
    std::vector<int> stops;
    double nofuel_penalty, check_penalty, step_penalty, recharge_penalty, wrong_charge_penalty, end_reward;
    double prob_correct_obs;
    double prob_open_station;

    mutable std::uniform_real_distribution<> unif_dist;
    CLOSE_BATTERY_UPDATER *updater = nullptr;

    int get_station_from_pos(const CLOSE_BATTERY_STATE& state, int pos) const;
    int get_next_station_pos(const CLOSE_BATTERY_STATE& state, int pos) const;
};


struct CLOSE_BATTERY_UPDATER {
    CLOSE_BATTERY_UPDATER(int total_lenght, int max_step = 4)
        : lenght(total_lenght), step(max_step), setup({}) {
            randomize_setup();
        }

    void set_sims(CLOSE_BATTERY *rl, CLOSE_BATTERY *sm) {
        real = rl;
        sim = sm;
    }

    void update() {
        randomize_setup();
        if (real) {
            real->update(setup);
        }
        if (sim) {
            sim->update(setup);
        }
    }

private:
    void randomize_setup() {
        setup.clear();
        int i = 0;
        while (i + step < lenght) {
            i += UTILS::Random(1, step + 1);
            setup.push_back(i);
        }
    }

    int lenght, step;
    std::vector<int> setup;
    CLOSE_BATTERY *real = nullptr;
    CLOSE_BATTERY *sim = nullptr;
};

