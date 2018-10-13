using Plotly
gr()

# Reading the data, structured

fn_tabs(str) = count(x -> x == '\t', str)

file = readchomp("data.txt");
lines = split(file, "\n");
filter!(l -> length(strip(l)) > 0, lines);
indent_lines = map(l -> (fn_tabs(l), strip(l)), lines);

function hierarch(indent_lines)
    inds = find(i_l -> i_l[1] == indent_lines[1][1], indent_lines)
    ends = [inds[2:end]; length(indent_lines) + 1]

    if length(inds) == length(indent_lines)
        return map(i_l -> map(x -> parse(Float64, x), split(i_l[2])), indent_lines)
    end

    d = Dict()
    for (i, e) in zip(inds, ends)
        d[indent_lines[i][2]] = hierarch(indent_lines[i+1:e-1])
    end

    return d
end

data = hierarch(indent_lines)

# Sensor Calibration
